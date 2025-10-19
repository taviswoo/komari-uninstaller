#!/bin/bash
set -e

echo "🧹 开始卸载 Komari 面板与探针..."

# 停止并删除 Docker 容器（如有）
if command -v docker >/dev/null; then
  echo "🔻 停止并删除 Komari 容器..."
  docker ps -a --format '{{.Names}}' | grep -i komari | while read cname; do
    docker stop "$cname"
    docker rm "$cname"
  done

  echo "🧼 删除相关镜像..."
  docker images --format '{{.Repository}}' | grep -i komari | while read img; do
    docker rmi "$img"
  done

  echo "🔻 停止并删除探针容器..."
  docker ps -a --format '{{.Names}}' | grep -i agent | while read aname; do
    docker stop "$aname"
    docker rm "$aname"
  done
else
  echo "⚠️ 未检测到 Docker，跳过容器卸载..."
fi

# 删除本地探针二进制文件
echo "🗑️ 删除本地探针文件..."
pkill -f komari-monitor-rs || true
rm -f /usr/local/bin/komari-monitor-rs

# 删除常见配置路径
echo "🧯 清理配置文件与挂载目录..."
rm -rf /opt/komari /etc/komari ~/komari* /root/komari*

# 清理 systemd 服务（如有）
echo "🧯 清理 systemd 服务..."
systemctl stop komari || true
systemctl disable komari || true
rm -f /etc/systemd/system/komari.service
rm -f /etc/systemd/system/komari-monitor.service
systemctl daemon-reload

# 检测残留
echo "🔍 开始检测残留..."

echo "📦 检查进程..."
ps aux | grep -Ei 'komari|agent' | grep -v grep && echo "⚠️ 存在残留进程" || echo "✅ 无残留进程"

echo "🌐 检查端口监听..."
if command -v ss >/dev/null; then
  ss -tulnp | grep -E '443|3000|8080' && echo "⚠️ 存在端口监听" || echo "✅ 无相关端口监听"
else
  echo "⚠️ ss 命令不可用，跳过端口检测"
fi

echo "🗂️ 检查文件路径..."
for path in /opt/komari /etc/komari /usr/local/bin/komari-monitor-rs ~/komari* /root/komari*; do
  [ -e "$path" ] && echo "⚠️ 残留文件：$path"
done

echo "✅ 卸载与检测完成。系统已清理干净（如无警告）。"
