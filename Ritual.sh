#!/bin/bash

# 更新系统包列表
sudo apt update

# 检查 Git 是否已安装
if ! command -v git &> /dev/null
then
    # 如果 Git 未安装，则进行安装
    echo "未检测到 Git，正在安装..."
    sudo apt install git -y
else
    # 如果 Git 已安装，则不做任何操作
    echo "Git 已安装。"
fi

# 克隆 ritual-net 仓库
git clone https://github.com/ritual-net/infernet-deploy

# 进入 infernet-deploy 目录
cd infernet-deploy/deploy

# 提示用户输入rpc_url
read -p "输入Base 主网Https RPC: " rpc_url

# 提示用户输入private_key
read -p "输入EVM钱包私钥，建议使用新钱包: " private_key

# 提示用户输入设置端口
read -p "输入端口: " port1

# 使用cat命令将配置写入config.json
cat > config.json <<EOF
{
  "log_path": "infernet_node.log",
  "server": {
    "port": $port1
  },
  "chain": {
    "enabled": true,
    "trail_head_blocks": 5,
    "rpc_url": "$rpc_url",
    "coordinator_address": "0x8D871Ef2826ac9001fB2e33fDD6379b6aaBF449c",
    "wallet": {
      "max_gas_limit": 5000000,
      "private_key": "$private_key"
    }
  },
  "docker": {
    "username": "",
    "password": ""
  },
  "redis": {
    "host": "redis",
    "port": 6379
  },
  "forward_stats": true,
  "startup_wait": 1.0,
  "containers": [
    {
      "id": "service-1",
      "image": "org1/image1:tag1",
      "description": "Container 1 description",
      "external": true,
      "port": "4999",
      "allowed_ips": ["XX.XX.XX.XXX", "XX.XX.XX.XXX"],
      "allowed_addresses": [""],
      "allowed_delegate_addresses": [""],
      "command": "--bind=0.0.0.0:3000 --workers=2",
      "env": {
        "KEY1": "VALUE1",
        "KEY2": "VALUE2"
      },
      "gpu": true
    },
    {
      "id": "service-2",
      "image": "org2/image2:tag2",
      "description": "Container 2 description",
      "external": false,
      "port": "4998",
      "allowed_ips": ["XX.XX.XX.XXX", "XX.XX.XX.XXX"],
      "allowed_addresses": ["0x..."],
      "allowed_delegate_addresses": ["0x..."],
      "command": "--bind=0.0.0.0:3000 --workers=2",
      "env": {
        "KEY3": "VALUE3",
        "KEY4": "VALUE4"
      }
    }
  ]
}
EOF

echo "Config 文件设置完成"

# 启动容器
docker compose up -d

echo "=========================安装完成======================================"
echo "请使用cd infernet-deploy/deploy 进入目录后，再使用docker compose logs -f 查询日志 "
