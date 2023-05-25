详细阅读README之后，你需要执行这个脚本并提供必要的参数（至少需要两个参数）。假如你已经有了公网 IP 地址，你还需要提供一个 overlay 网络的名称。以下是如何执行脚本的步骤：

1. 首先，你需要下载这个脚本到你的 Ubuntu 服务器。使用 wget 命令可以完成这个任务：

    ```bash
    wget https://raw.githubusercontent.com/aifllow/Automatically-Deploy-Docker-Swarm-Cluster/main/ADDSC.sh
    ```

    注意：我们需要访问 GitHub 仓库中的 raw 文件，因此 URL 需要更改为上面的形式。

2. 接下来，给这个脚本执行权限：

    ```bash
    chmod +x ADDSC.sh
    ```

3. 现在你可以执行这个脚本了。这个脚本需要至少两个参数：公网 IP 地址和网络名称。以下是一个例子，使用你的公网 IP 地址，并假设你想创建一个叫做 "my_network" 的 overlay 网络：

    ```bash
    sudo ./ADDSC.sh 8.8.8.8 my_network
    ```

    这个脚本还接受其他可选的参数，比如 Swarm 端口和工作节点的公网 IP 地址。如果你需要设置这些参数，你可以在上面的命令后面添加它们。例如，如果你想设置 Swarm 端口为 4000，并添加两个工作节点的 IP 地址，你可以这样执行脚本：

    ```bash
    sudo ./ADDSC.sh 8.8.8.8 my_network 4000 192.168.1.1 192.168.1.2
    ```

请注意，这个脚本需要管理员权限来执行，因此我们使用了 `sudo` 命令。如果你在执行这个脚本时遇到任何问题，你可能需要检查你的网络连接和 IP 地址的有效性，或者联系这个脚本的作者寻求帮助。
