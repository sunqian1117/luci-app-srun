# Srun 认证客户端安装指南

[English](#english-installation-guide) | [中文](#中文安装指南)

---

## 中文安装指南

### 目录
1. [方法一：使用预编译的 IPK 包（推荐）](#方法一使用预编译的-ipk-包推荐)
2. [方法二：手动安装](#方法二手动安装)
3. [方法三：自己构建 IPK 包](#方法三自己构建-ipk-包)
4. [配置说明](#配置说明)
5. [使用说明](#使用说明)
6. [故障排查](#故障排查)

---

### 方法一：使用预编译的 IPK 包（推荐）

这是最简单的安装方法，适合大多数用户。

#### 步骤 1：下载 IPK 包

1. 在电脑上访问本项目的 [Releases 页面](https://github.com/sunqian1117/luci-app-srun/releases)
2. 下载最新版本的 `luci-app-srun_x.x.x-x_all.ipk` 文件到电脑

#### 步骤 2：上传到路由器

**方法 A - 使用 SCP（推荐）：**

在电脑的命令行中执行：
```bash
# Windows 用户请使用 PowerShell 或安装 WinSCP
# Mac/Linux 用户直接在终端执行
scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
```

**方法 B - 使用 WinSCP（Windows 用户）：**
1. 下载并安装 [WinSCP](https://winscp.net/)
2. 连接到路由器（主机：192.168.1.1，用户名：root，密码：你的路由器密码）
3. 将 IPK 文件上传到 `/tmp/` 目录

**方法 C - 使用 LuCI Web 界面：**
1. 登录路由器管理界面（通常是 http://192.168.1.1）
2. 进入"系统" -> "文件传输"
3. 上传 IPK 文件到 `/tmp/` 目录

#### 步骤 3：SSH 连接到路由器

```bash
ssh root@192.168.1.1
# 输入路由器密码
```

#### 步骤 4：安装依赖包

```bash
# 更新软件包列表
opkg update

# 安装必需的依赖
opkg install curl jsonfilter coreutils-base64 openssl-util
```

#### 步骤 5：安装 IPK 包

```bash
# 进入临时目录
cd /tmp

# 安装软件包
opkg install luci-app-srun_*.ipk
```

安装成功后会显示类似信息：
```
Installing luci-app-srun (1.0.0-1) to root...
Configuring luci-app-srun.
Srun authentication client installed successfully!
Please configure /etc/config/srun and run: /etc/init.d/srun start
```

#### 步骤 6：配置和启动

参见后面的[配置说明](#配置说明)章节。

---

### 方法二：手动安装

如果没有预编译的 IPK 包，可以手动安装。

#### 步骤 1：下载源码

在电脑上：
```bash
# 下载源码压缩包
wget https://github.com/sunqian1117/luci-app-srun/archive/refs/heads/main.zip
# 或者使用 git clone
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
```

#### 步骤 2：上传到路由器

```bash
# 打包源码
tar czf luci-app-srun.tar.gz root/ luasrc/

# 上传到路由器
scp luci-app-srun.tar.gz root@192.168.1.1:/tmp/
```

#### 步骤 3：在路由器上安装

SSH 连接到路由器：
```bash
ssh root@192.168.1.1
```

执行安装命令：
```bash
# 安装依赖
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util

# 解压并安装
cd /tmp
tar xzf luci-app-srun.tar.gz

# 设置执行权限
chmod +x root/usr/bin/srun-auth
chmod +x root/usr/lib/srun/crypto.sh
chmod +x root/etc/init.d/srun
chmod +x root/etc/hotplug.d/iface/99-srun

# 复制文件到系统
cp -r root/* /
cp -r luasrc/* /usr/lib/lua/luci/

# 启用服务
/etc/init.d/srun enable
```

---

### 方法三：自己构建 IPK 包

如果你想自己构建 IPK 包（例如修改了源码）。

#### 在 Linux 电脑上构建

```bash
# 1. 克隆源码
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 2. 运行构建脚本
./build-ipk.sh

# 3. 构建完成后，会在当前目录生成 IPK 文件
ls -l *.ipk
```

#### 在 Windows 电脑上构建

**使用 WSL（Windows Subsystem for Linux）：**

1. 安装 WSL（如果还没有）：
   - 打开 PowerShell（管理员模式）
   - 运行：`wsl --install`
   - 重启电脑

2. 在 WSL 中构建：
```bash
# 打开 WSL 终端
wsl

# 克隆源码
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 运行构建脚本
./build-ipk.sh

# 查看生成的 IPK 文件
ls -l *.ipk

# 复制到 Windows 目录
cp *.ipk /mnt/c/Users/你的用户名/Downloads/
```

**使用 Docker（适用于 Windows/Mac/Linux）：**

```bash
# 1. 确保已安装 Docker Desktop

# 2. 克隆源码
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 3. 使用 Docker 构建
docker run --rm -v ${PWD}:/work -w /work ubuntu:22.04 bash -c "
    apt-get update && 
    apt-get install -y tar gzip && 
    ./build-ipk.sh
"

# 4. 查看生成的 IPK 文件
ls -l *.ipk
```

构建完成后，使用[方法一](#方法一使用预编译的-ipk-包推荐)的步骤 2-6 来安装。

---

### 配置说明

安装完成后，需要配置认证信息。

#### 方法 A：使用 LuCI Web 界面（推荐）

1. 在浏览器中访问路由器管理界面：http://192.168.1.1
2. 登录后，进入"服务" -> "Srun 认证"
3. 填写配置信息：
   - **启用**：勾选此选项
   - **认证服务器**：填写学校的 Srun 服务器地址，例如：`http://10.0.0.1` 或 `http://auth.university.edu.cn`
   - **用户名**：填写你的学号或用户名
   - **密码**：填写你的认证密码
   - **网络接口**：通常选择 `wan`
   - **AC ID**：通常保持默认值 `1`（具体值请咨询学校网络中心）
   - **自动登录**：勾选此选项以启用开机自动认证
4. 点击"保存&应用"

#### 方法 B：使用命令行配置

SSH 连接到路由器后，编辑配置文件：

```bash
vi /etc/config/srun
```

修改为你的配置：
```
config basic 'basic'
    option enabled '1'
    option server 'http://your-srun-server.edu.cn'
    option username 'your-student-id'
    option password 'your-password'
    option interface 'wan'
    option acid '1'
    option auto_login '1'
```

保存后重启服务：
```bash
/etc/init.d/srun restart
```

---

### 使用说明

#### 启动和停止服务

```bash
# 启动服务
/etc/init.d/srun start

# 停止服务
/etc/init.d/srun stop

# 重启服务
/etc/init.d/srun restart

# 设置开机自启
/etc/init.d/srun enable

# 禁用开机自启
/etc/init.d/srun disable
```

#### 手动登录和注销

```bash
# 手动登录
srun-auth login

# 手动注销
srun-auth logout

# 查看状态
srun-auth status

# 查看日志
srun-auth log
```

#### 查看运行日志

```bash
# 查看最近的日志
tail -f /var/log/srun.log

# 查看全部日志
cat /var/log/srun.log
```

---

### 故障排查

#### 问题 1：安装依赖时出现错误

**错误信息**：`Unknown package 'curl'` 或 `Failed to download`

**解决方法**：
```bash
# 更新软件源
opkg update

# 如果仍然失败，可能需要配置正确的软件源
# 编辑 /etc/opkg/distfeeds.conf 文件
vi /etc/opkg/distfeeds.conf

# 确保软件源地址正确，例如：
# src/gz openwrt_core https://downloads.openwrt.org/releases/22.03.0/targets/...
# src/gz openwrt_base https://downloads.openwrt.org/releases/22.03.0/packages/.../base
```

#### 问题 2：认证失败

**检查步骤**：

1. 确认配置信息正确：
```bash
cat /etc/config/srun
```

2. 检查网络连接：
```bash
ping -c 4 your-srun-server-ip
```

3. 查看详细日志：
```bash
srun-auth login
tail -20 /var/log/srun.log
```

4. 检查服务器地址格式（必须包含 `http://` 或 `https://`）

#### 问题 3：Web 界面找不到 Srun 选项

**解决方法**：
```bash
# 清除 LuCI 缓存
rm -rf /tmp/luci-*

# 重启 uhttpd 服务
/etc/init.d/uhttpd restart

# 刷新浏览器（Ctrl+F5 强制刷新）
```

#### 问题 4：开机不自动登录

**检查步骤**：

1. 确认服务已启用：
```bash
/etc/init.d/srun enabled && echo "已启用" || echo "未启用"
```

2. 确认配置中的 auto_login 为 1：
```bash
uci get srun.basic.auto_login
```

3. 手动启用：
```bash
/etc/init.d/srun enable
uci set srun.basic.auto_login='1'
uci commit srun
```

#### 问题 5：显示权限错误

**解决方法**：
```bash
# 重新设置执行权限
chmod +x /usr/bin/srun-auth
chmod +x /usr/lib/srun/crypto.sh
chmod +x /etc/init.d/srun
chmod +x /etc/hotplug.d/iface/99-srun
```

---

### 卸载

如果需要卸载：

```bash
# 停止并禁用服务
/etc/init.d/srun stop
/etc/init.d/srun disable

# 卸载软件包
opkg remove luci-app-srun

# 或者手动删除文件
rm -f /usr/bin/srun-auth
rm -rf /usr/lib/srun
rm -f /etc/init.d/srun
rm -f /etc/config/srun
rm -f /etc/hotplug.d/iface/99-srun
rm -rf /usr/lib/lua/luci/controller/srun.lua
rm -rf /usr/lib/lua/luci/model/cbi/srun.lua
rm -rf /usr/lib/lua/luci/view/srun
```

---

### 常见问题（FAQ）

**Q: 支持哪些 OpenWrt 版本？**
A: 支持 OpenWrt 19.07 及以上版本，包括 21.02 和 22.03。

**Q: 需要什么样的路由器？**
A: 任何运行 OpenWrt 系统的路由器都可以使用，建议至少 32MB RAM。

**Q: 是否支持多账号认证？**
A: 当前版本只支持单账号认证。

**Q: 认证失败怎么办？**
A: 请先确认用户名密码正确，服务器地址正确，然后查看日志排查问题。

**Q: 如何获取学校的 Srun 服务器地址？**
A: 通常可以咨询学校网络中心，或者在连接校园网时抓包获取。

---

## English Installation Guide

### Quick Installation (Method 1 - Using IPK Package)

#### Step 1: Download IPK Package
Download the latest `luci-app-srun_x.x.x-x_all.ipk` from [Releases](https://github.com/sunqian1117/luci-app-srun/releases)

#### Step 2: Upload to Router
```bash
scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
```

#### Step 3: Install Dependencies
```bash
ssh root@192.168.1.1
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

#### Step 4: Install Package
```bash
cd /tmp
opkg install luci-app-srun_*.ipk
```

#### Step 5: Configure
Edit `/etc/config/srun` with your credentials:
```
config basic 'basic'
    option enabled '1'
    option server 'http://your-srun-server'
    option username 'your-username'
    option password 'your-password'
    option interface 'wan'
    option acid '1'
    option auto_login '1'
```

#### Step 6: Start Service
```bash
/etc/init.d/srun enable
/etc/init.d/srun start
```

### Building IPK Package

On Linux:
```bash
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
./build-ipk.sh
```

The IPK file will be generated in the current directory.

---

**如有问题，请在 GitHub Issues 中提出：https://github.com/sunqian1117/luci-app-srun/issues**
