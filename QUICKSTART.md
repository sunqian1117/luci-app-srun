# 快速开始指南 / Quick Start Guide

[中文](#中文快速开始) | [English](#english-quick-start)

---

## 中文快速开始

### 5 分钟快速安装

#### 1️⃣ 下载 IPK 包

从 [Releases 页面](https://github.com/sunqian1117/luci-app-srun/releases) 下载 `luci-app-srun_x.x.x-x_all.ipk`

或使用 wget 直接下载（在路由器上）：
```bash
cd /tmp
wget https://github.com/sunqian1117/luci-app-srun/releases/download/v1.0.0/luci-app-srun_1.0.0-1_all.ipk
```

#### 2️⃣ 上传到路由器

**Windows 用户：**
- 下载 [WinSCP](https://winscp.net/)
- 连接到路由器（192.168.1.1，用户：root）
- 上传 IPK 文件到 `/tmp/` 目录

**Mac/Linux 用户：**
```bash
scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
```

#### 3️⃣ 安装

SSH 连接到路由器：
```bash
ssh root@192.168.1.1
```

执行安装命令：
```bash
# 更新软件包列表
opkg update

# 安装依赖
opkg install curl jsonfilter coreutils-base64 openssl-util

# 安装软件包
cd /tmp
opkg install luci-app-srun_*.ipk
```

#### 4️⃣ 配置

**方式 A - Web 界面（推荐）：**
1. 浏览器访问：http://192.168.1.1
2. 进入"服务" -> "Srun 认证"
3. 勾选"启用"
4. 填写：
   - 认证服务器：`http://your-server-ip`
   - 用户名：你的学号
   - 密码：你的密码
5. 点击"保存&应用"

**方式 B - 命令行：**
```bash
vi /etc/config/srun

# 修改为：
config basic 'basic'
    option enabled '1'
    option server 'http://10.0.0.1'
    option username '20210001'
    option password 'yourpassword'
    option interface 'wan'
    option acid '1'
    option auto_login '1'
```

#### 5️⃣ 启动

```bash
# 启动服务
/etc/init.d/srun start

# 设置开机自启
/etc/init.d/srun enable

# 手动登录测试
srun-auth login

# 查看状态
srun-auth status
```

### 验证安装

登录成功后，你应该能看到：
```bash
$ srun-auth status
online
20210001
192.168.1.100
```

查看日志：
```bash
$ srun-auth log
2024-12-15 15:30:00 - Attempting login: user=20210001, ip=192.168.1.100
2024-12-15 15:30:01 - Login successful
```

---

## English Quick Start

### 5-Minute Installation

#### 1️⃣ Download IPK Package

Download `luci-app-srun_x.x.x-x_all.ipk` from [Releases](https://github.com/sunqian1117/luci-app-srun/releases)

Or use wget on your router:
```bash
cd /tmp
wget https://github.com/sunqian1117/luci-app-srun/releases/download/v1.0.0/luci-app-srun_1.0.0-1_all.ipk
```

#### 2️⃣ Upload to Router

```bash
scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
```

#### 3️⃣ Install

SSH to your router:
```bash
ssh root@192.168.1.1
```

Install the package:
```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
cd /tmp
opkg install luci-app-srun_*.ipk
```

#### 4️⃣ Configure

Edit config file:
```bash
vi /etc/config/srun

# Set your credentials:
config basic 'basic'
    option enabled '1'
    option server 'http://your-server-ip'
    option username 'your-username'
    option password 'your-password'
    option interface 'wan'
    option acid '1'
    option auto_login '1'
```

#### 5️⃣ Start Service

```bash
/etc/init.d/srun enable
/etc/init.d/srun start
srun-auth login
```

### Verify Installation

```bash
$ srun-auth status
online
your-username
192.168.1.100
```

---

## 🔍 需要帮助？ Need Help?

- 📖 [完整安装指南 / Full Installation Guide](INSTALL.md)
- 📝 [项目说明 / README](README.md)
- 🐛 [报告问题 / Report Issues](https://github.com/sunqian1117/luci-app-srun/issues)

---

## ⚡ 常用命令 / Common Commands

```bash
# 手动登录 / Manual login
srun-auth login

# 手动注销 / Manual logout
srun-auth logout

# 查看状态 / Check status
srun-auth status

# 查看日志 / View logs
srun-auth log

# 启动服务 / Start service
/etc/init.d/srun start

# 停止服务 / Stop service
/etc/init.d/srun stop

# 重启服务 / Restart service
/etc/init.d/srun restart
```
