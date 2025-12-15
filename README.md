# LuCI App Srun - 深澜校园网认证

OpenWrt 平台的深澜（Srun）校园网认证客户端，支持自动登录、断线重连和 Web 界面配置。

## 功能特性

- ✅ 完整的深澜 Srun Portal 认证协议支持
- ✅ 自动登录和断线重连
- ✅ LuCI Web 界面配置
- ✅ 支持手动登录/注销
- ✅ 实时状态显示和日志查看
- ✅ 开机自动认证
- ✅ 网络热插拔自动认证

## 快速安装

### 方法一：手动安装（最简单）

```bash
# 1. 连接到路由器
ssh root@192.168.1.1

# 2. 安装依赖
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util

# 3. 下载脚本
cd /tmp
wget https://github.com/sunqian1117/luci-app-srun/archive/refs/heads/main.zip
unzip main.zip
cd luci-app-srun-main

# 4. 安装
chmod +x root/usr/bin/srun-auth
chmod +x root/usr/lib/srun/crypto.sh
cp -r root/* /
cp -r luasrc/* /usr/lib/lua/luci/

# 5. 配置
vi /etc/config/srun  # 填写用户名密码
/etc/init.d/srun enable
/etc/init.d/srun start
