#!/bin/bash
set -e

echo "🧹 开始卸载 Komari 面板与探针..."

# 停止并删除 Docker 容器
echo "🔻 停止并删除 Komari 容器..."
docker ps -a --format '{{.Names}}' | grep -i komari | while read cname; do
  docker stop "$cname"
  docker rm "$cname"
done

# 删除 Komari 镜像
echo "🧼 删除相关镜像..."
docker images --format '{{.Repository}}' | grep -i komari | while read img; do
  docker rmi "$img"
done

# 删除 Komari 探针容器（如 komari-agent）
echo "🔻 停止并删除探针容器..."
docker ps -a --format '{{.Names}}' | grep -i agent | while read aname; do
  docker stop "$aname"
  docker rm "$aname"
done

# 删除 Komari 配置目录（根据常见路径）
echo "🗑️ 删除配置文件与挂载目录..."
rm -rf /opt/komari
rm -rf /etc/komari
rm -rf /root/komari*
rm -rf ~/komari*

# 清理 systemd 服务（如有）
echo "🧯 清理 systemd 服务..."
systemctl stop komari || true
systemctl disable komari || true
rm -f /etc/systemd/system/komari.service
systemctl daemon-reload

# 清理残留进程（如有）
echo "🧼 清理残留进程..."
pkill -f komari || true
pkill -f agent || true

echo "✅ Komari 面板与探针已彻底卸载完成。"
