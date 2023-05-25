#!/bin/bash
# 这个脚本用于安装 Docker，初始化 Docker Swarm，创建 overlay 网络，并添加工作节点到 Swarm。
#
# 用法: ./script.sh <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]
# 参数:
#   <公网 IP 地址>     - 用于 Swarm 的公网 IP 地址。
#   <网络名称>         - 要创建的 overlay 网络的名称。
#   [<Swarm 端口>]     - Swarm 的端口号，默认为 2377。
#   [<工作节点 IP 地址>...] - 要添加到 Swarm 的工作节点的公网 IP 地址。

function log_error() {
    local msg="$1"
    echo "ERROR: ${msg}" 1>&2
    exit 1
}

function check_installed() {
    local soft_name=$1
    command -v $soft_name > /dev/null
    return $?
}

function install_soft() {
    local install_cmd=$1
    local install_pkgs=$2
    local soft_name=$3

    if ! check_installed $soft_name; then
        $install_cmd $install_pkgs
        if ! check_installed $soft_name; then
            log_error "$soft_name 安装失败。请检查网络连接或手动安装。"
        fi
    fi
}

function install_docker() {
    if [ -f /etc/centos-release ]; then
        install_soft "sudo yum install -y yum-utils; sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo; sudo yum install -y" "docker-ce docker-ce-cli containerd.io" "docker"
    elif [ -f /etc/lsb-release ]; then
        install_soft "sudo apt-get update; sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -; sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"; sudo apt-get update; sudo apt-get install -y" "docker-ce" "docker"
    elif [ -f /etc/debian_version ]; then
        install_soft "sudo apt-get update; sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common; curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -; sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"; sudo apt-get update; sudo apt-get install -y" "docker-ce" "docker"
    else
        log_error "不支持的操作系统。请手动安装 Docker。"
    fi
}

function validate_ip() {
    local ip=$1
    local stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            if [[ $i -le 255 && $i -ge 0 ]]; then
                stat=0
            else
                stat=1
                break
            fi
        done
    fi
    return $stat
}

function add_worker_nodes() {
    for worker_ip in ${worker_ips[@]}; do
        if validate_ip $worker_ip; then
            docker swarm join --token $token --advertise-addr $worker_ip $public_ip:$swarm_port || log_error "工作节点 $worker_ip 加入 Swarm 失败。请检查 Swarm 状态和工作节点 IP。"
        else
            log_error "无效的 IP 地址: ${worker_ip}"
        fi
    done
}

function main() {
    if [[ $# -lt 2 ]]; then
        log_error "使用方法: $0 <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]"
    fi

    public_ip=${1}
    network_name=${2}
    swarm_port=${3:-"2377"}
    worker_ips=(${@:4})

    install_docker

    docker network create --driver overlay --opt encrypted $network_name || log_error "创建 overlay 网络失败。"
    docker swarm init --advertise-addr $public_ip:$swarm_port || log_error "初始化 Swarm 失败。"

    token_file="/root/swarm_token"
    token=$(docker swarm join-token -q worker) || log_error "获取 Swarm token 失败。请检查 Swarm 状态。"
    echo "$token" > $token_file
    chmod 600 $token_file

    add_worker_nodes
}

main "$@"
