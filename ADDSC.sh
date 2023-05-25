#!/bin/bash
# 这个脚本用于安装 Docker，初始化 Docker Swarm，创建 overlay 网络，并添加工作节点到 Swarm。
#
# 用法: ./ADDSC.sh <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]
# 参数:
#   <公网 IP 地址>     - 用于 Swarm 的公网 IP 地址。
#   <网络名称>         - 要创建的 overlay 网络的名称。
#   [<Swarm 端口>]     - Swarm 的端口号，默认为 2377。
#   [<工作节点 IP 地址>...] - 要添加到 Swarm 的工作节点的公网 IP 地址。

# 打印错误信息并退出脚本
function log_error() {
    local msg="$1"
    echo "ERROR: ${msg}" 1>&2
    exit 1
}

# 检查指定的命令是否可以在系统中运行
function check_installed() {
    local soft_name=$1
    command -v $soft_name > /dev/null
    return $?
}

# 安装指定的软件包
function install_soft() {
    local install_cmd=$1
    local install_pkgs=$2
    local soft_name=$3

    # 如果未安装软件，则尝试安装
    if ! check_installed $soft_name; then
        $install_cmd $install_pkgs
        # 如果安装失败，则打印错误信息并退出脚本
        if ! check_installed $soft_name; then
            log_error "$soft_name 安装失败。请检查网络连接或手动安装。"
        fi
    fi
}

# 安装 Docker
function install_docker() {
    # 根据不同的操作系统安装 Docker
    if [ -f /etc/centos-release ]; then
        install_soft "sudo yum install -y yum-utils; sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo; sudo yum install -y" "docker-ce docker-ce-cli containerd.io" "docker"
    elif [ -f /etc/lsb-release ]; then
        install_soft "sudo apt-get update; sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -; sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"; sudo apt-get update; sudo apt-get install -y" "docker-ce" "docker"
    elif [ -f /etc/debian_version ]; then
        install_soft "sudo apt-get update; sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common; curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -; sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable\"; sudo apt-get update; sudo apt-get install -y" "docker-ce"# 第二部分的代码
```bash
    "docker"
    else
        log_error "不支持的操作系统。请手动安装 Docker。"
    fi
}

# 验证 IP 地址格式
function validate_ip() {
    local ip=$1
    local stat=1
    # 验证 IP 地址格式，如果符合格式要求，则进一步验证每个字段的值是否在 0-255 之间
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        stat=0
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            # 如果 IP 地址的每个字段都在 0-255 之间，则返回 0，表示 IP 地址有效
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

# 添加工作节点到 Swarm
function add_worker_nodes() {
    # 对每个工作节点的 IP 地址进行遍历
    for worker_ip in ${worker_ips[@]}; do
        # 验证 IP 地址的有效性
        if validate_ip $worker_ip; then
            # 尝试添加工作节点到 Swarm，如果失败，则打印错误信息
            docker swarm join --token $token --advertise-addr $worker_ip $public_ip:$swarm_port || log_error "工作节点 $worker_ip 加入 Swarm 失败。请检查 Swarm 状态和工作节点 IP。"
        else
            log_error "无效的 IP 地址: ${worker_ip}"
        fi
    done
}

# 主函数
function main() {
    # 检查是否提供了至少两个参数（公网 IP 地址和网络名称）
    if [[ $# -lt 2 ]]; then
        log_error "使用方法: $0 <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]"
    fi

    # 获取公网 IP 地址、网络名称、Swarm 端口和工作节点 IP 地址
    public_ip=${1}
    network_name=${2}
    swarm_port=${3:-"2377"}
    worker_ips=(${@:4})

    # 安装 Docker
    install_docker

    # 创建 overlay 网络，如果失败，则打印错误信息
    docker network create --driver overlay --opt encrypted $network_name || log_error "创建 overlay 网络失败。"

    # 初始化 Swarm，如果失败，则打印错误信息
    docker swarm init --advertise-addr $public_ip:$swarm_port || log_error "初始化 Swarm 失败。"

    # 获取 Swarm token，如果失败，则打印错误信息
    token_file="/root/swarm_token"
    token=$(docker swarm join-token -q worker) || log_error "获取 Swarm token 失败。请检查 Swarm 状态。"
    
    # 将 Swarm token 写入到文件中，方便后续使用
    echo "$token" > $token_file
    chmod 600 $token_file

    # 添加工作节点到 Swarm
    addInvalid function call in source code: ```bash
"docker"
else
log_error "不支持的操作系统。请手动安装 Docker。"
fi
}
function validate_ip() {
local ip=$1
local stat=1
# 验证 IP 地址格式，如果符合格式要求，则进一步验证每个字段的值是否在 0-255 之间
if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
stat=0
IFS='.' read -ra ADDR <<< "$ip"
for i in "${ADDR[@]}"; do
# 如果 IP 地址的每个字段都在 0-255 之间，则返回 0，表示 IP 地址有效
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
# 对每个工作节点的 IP 地址进行遍历
for worker_ip in ${worker_ips[@]}; do
# 验证 IP 地址的有效性
if validate_ip $worker_ip; then
# 尝试添加工作节点到 Swarm，如果失败，则打印错误信息
docker swarm join --token $token --advertise-addr $worker_ip $public_ip:$swarm_port || log_error "工作节点 $worker_ip 加入 Swarm 失败。请检查 Swarm 状态和工作节点 IP。"
else
log_error "无效的 IP 地址: ${worker_ip}"
fi
done
}
function main() {
# 检查是否提供了至少两个参数（公网 IP 地址和网络名称）
if [[ $# -lt 2 ]]; then
log_error "使用方法: $0 <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]"
fi
# 获取公网 IP 地址、网络名称、Swarm 端口和工作节点 IP 地址
public_ip=${1}
network_name=${2}
swarm_port=${3:-"2377"}
worker_ips=(${@:4})
# 安装 Docker
install_docker
# 创建 overlay 网络，如果失败，则打印错误信息
docker network create --driver overlay --opt encrypted $network_name || log_error "创建 overlay 网络失败。"
# 初始化 Swarm，如果失败，则打印错误信息
docker swarm init --advertise-addr $public_ip:$swarm_port || log_error "初始化 Swarm 失败。"
# 获取 Swarm token，如果失败，则打印错误信息
token_file="/root/swarm_token"
token=$(docker swarm join-token -q worker) || log_error "获取 Swarm token 失败。请检查 Swarm 状态。"
# 将 Swarm token 写入到文件中，方便后续使用
echo "$token" > $token_file
chmod 600 $token_file
# 添加工作节点到 Swarm
add
