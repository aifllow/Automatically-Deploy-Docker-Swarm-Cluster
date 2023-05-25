# Automatically-Deploy-Docker-Swarm-Cluster
# Docker Swarm 初始化脚本

这个 Bash 脚本用于安装 Docker，初始化 Docker Swarm，创建 overlay 网络，并添加工作节点到 Swarm。

## 使用方法

你可以运行脚本，提供以下参数：

```bash
./script.sh <公网 IP 地址> <网络名称> [<Swarm 端口>] [<工作节点 IP 地址>...]
```

参数解释：

- `<公网 IP 地址>`: 用于 Swarm 的公网 IP 地址。
- `<网络名称>`: 要创建的 overlay 网络的名称。
- `<Swarm 端口>`: Swarm 的端口号，这是可选的参数，默认为 2377。
- `<工作节点 IP 地址>...`: 要添加到 Swarm 的工作节点的公网 IP 地址，这是可选的参数，可以提供多个。

## 脚本说明

脚本主要完成以下几个步骤：

1. 安装 Docker：脚本会自动检测系统类型并尝试安装 Docker。支持的系统类型包括 CentOS，Ubuntu 和 Debian。如果系统类型不在这些之中，脚本会提示用户手动安装 Docker。

2. 验证 IP 地址：脚本会验证提供的公网 IP 地址和工作节点 IP 地址的有效性。如果 IP 地址不符合格式要求或者每个字段的值不在 0-255 之间，脚本会提示错误。

3. 初始化 Docker Swarm：脚本会使用提供的公网 IP 地址和端口号初始化 Docker Swarm。如果初始化失败，脚本会提示错误。

4. 创建 overlay 网络：脚本会创建一个新的 overlay 网络，网络名称由用户提供。如果创建网络失败，脚本会提示错误。

5. 添加工作节点到 Swarm：脚本会将提供的每个工作节点 IP 地址添加到 Swarm 中。如果添加工作节点失败，脚本会提示错误。

6. Swarm token：脚本会获取 Swarm token 并将其写入到文件中，方便后续使用。如果获取 Swarm token 失败，脚本会提示错误。

## 错误处理

脚本中包含了错误处理函数，可以在遇到错误时打印错误信息并终止脚本执行。

## 注意事项

- 运行脚本需要具有管理员权限，因为安装 Docker 和操作 Swarm 都需要管理员权限。
- 如果你在使用脚本时遇到任何问题，建议首先检查网络连接和 IP 地址的有效性。
- 在添加工作节点到 Swarm 时，请确保工作节点可以访问到 Swarm 的公网 IP 地址和端口号。

希望这个脚本可以帮助你更方便地管理和操作 Docker Swarm！
