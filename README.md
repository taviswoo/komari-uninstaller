# 🧹 Komari 面板与探针一键卸载脚本

本脚本用于彻底卸载 Komari 面板与探针，包括容器、镜像、配置文件、systemd 服务等残留项。适用于大多数 Linux VPS 环境（如 Debian/Ubuntu/CentOS）。

## 📦 功能清单

- 停止并删除 Komari 面板容器
- 停止并删除 Komari 探针容器（如 komari-agent）
- 删除相关 Docker 镜像
- 清理配置文件与挂载目录
- 移除 systemd 服务（如有）
- 杀死残留进程

## 🚀 使用方法

1. 下载脚本：
   ```bash
   curl -O https://raw.githubusercontent.com/taviswoo/komari-uninstaller/main/uninstall-komari.sh
2. 赋予权限
   ```bash
   chmod +x uninstall-komari.sh
4. 执行脚本
   ```bash
   sudo ./uninstall-komari.sh
