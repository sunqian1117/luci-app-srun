# 构建与打包完整指南

## 📦 什么是 IPK 包？

IPK (Itsy Package) 是 OpenWrt 使用的软件包格式，类似于 Debian 的 .deb 包或 RedHat 的 .rpm 包。IPK 包可以在 OpenWrt 路由器上使用 `opkg` 命令进行安装、升级和卸载。

## 🎯 本项目提供的解决方案

本项目已经为你准备好了完整的构建系统，你可以：

### 方案 1：直接使用预构建的 IPK 包（最简单）

**适合人群**：普通用户，只想快速安装使用

从 [Releases](https://github.com/sunqian1117/luci-app-srun/releases) 页面下载预构建的 IPK 包，直接安装即可。

参考：[QUICKSTART.md](QUICKSTART.md)

### 方案 2：在电脑上自己构建 IPK 包

**适合人群**：想要自定义或修改代码的用户

本项目提供了 `build-ipk.sh` 脚本，可以在任何 Linux 环境中快速构建 IPK 包。

---

## 🔨 如何在电脑上构建 IPK 包

### Linux 用户（推荐）

#### 前置条件
- 已安装 Git
- 已安装 tar 和 gzip（通常系统自带）

#### 构建步骤

```bash
# 1. 克隆仓库
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 2. 运行构建脚本
./build-ipk.sh

# 3. 构建完成！
# IPK 文件已生成：luci-app-srun_1.0.0-1_all.ipk
```

就这么简单！

---

### Windows 用户

Windows 用户有两种方式构建：

#### 方式 A：使用 WSL（推荐）

WSL (Windows Subsystem for Linux) 可以让你在 Windows 上运行 Linux 环境。

**1. 安装 WSL**

打开 PowerShell（管理员模式）：
```powershell
wsl --install
```

重启电脑后，WSL 会自动完成安装。

**2. 在 WSL 中构建**

打开"开始菜单" -> 输入 "Ubuntu" -> 打开 Ubuntu 终端

```bash
# 安装 Git（如果还没有）
sudo apt update
sudo apt install git

# 克隆仓库
cd ~
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 运行构建脚本
./build-ipk.sh

# 查看生成的文件
ls -lh *.ipk
```

**3. 复制到 Windows**

```bash
# 复制 IPK 文件到 Windows 下载目录
# 将 "YourUsername" 替换为你的 Windows 用户名
cp luci-app-srun_*.ipk /mnt/c/Users/YourUsername/Downloads/
```

现在你可以在 Windows 的"下载"文件夹中找到 IPK 文件了！

#### 方式 B：使用 Docker

如果你已经安装了 Docker Desktop：

**1. 克隆仓库**

在 Windows 命令提示符或 PowerShell 中：
```cmd
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
```

**2. 使用 Docker 构建**

```cmd
docker run --rm -v %cd%:/work -w /work ubuntu:22.04 bash -c "apt-get update && apt-get install -y tar gzip && ./build-ipk.sh"
```

或在 PowerShell 中：
```powershell
docker run --rm -v ${PWD}:/work -w /work ubuntu:22.04 bash -c "apt-get update && apt-get install -y tar gzip && ./build-ipk.sh"
```

构建完成后，IPK 文件会出现在当前目录。

#### 方式 C：使用 Git Bash

如果你已经安装了 Git for Windows：

1. 打开 Git Bash
2. 执行与 Linux 相同的命令

```bash
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
./build-ipk.sh
```

---

### macOS 用户

macOS 的构建过程与 Linux 完全相同：

```bash
# 1. 克隆仓库
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 2. 运行构建脚本
./build-ipk.sh

# 3. 完成！
ls -lh *.ipk
```

---

## 📋 构建脚本做了什么？

`build-ipk.sh` 脚本会自动完成以下步骤：

1. **创建目录结构**
   - 创建 `build/ipk/data/` 用于存放软件文件
   - 创建 `build/ipk/control/` 用于存放控制文件

2. **复制文件**
   - 复制 `root/*` 中的系统文件
   - 复制 `luasrc/*` 中的 LuCI 界面文件
   - 设置正确的文件权限

3. **生成控制文件**
   - `control` - 包含包信息（名称、版本、依赖等）
   - `postinst` - 安装后执行的脚本
   - `prerm` - 卸载前执行的脚本

4. **打包**
   - 创建 `data.tar.gz` - 包含所有软件文件
   - 创建 `control.tar.gz` - 包含控制文件
   - 创建 `debian-binary` - 标识包格式版本
   - 将以上三个文件打包成最终的 `.ipk` 文件

5. **清理**
   - 临时文件保留在 `build/` 目录中
   - 最终的 `.ipk` 文件在项目根目录

---

## 🔍 检查构建结果

构建完成后，你可以检查 IPK 包的内容：

```bash
# 查看 IPK 文件信息
ls -lh *.ipk

# 查看 IPK 包含的文件列表
tar -tzf luci-app-srun_*.ipk

# 提取并查看控制文件
cd build
tar -xzf control.tar.gz
cat control
```

控制文件应该类似这样：
```
Package: luci-app-srun
Version: 1.0.0-1
Depends: curl, jsonfilter, coreutils-base64, openssl-util
Section: luci
Architecture: all
Installed-Size: 11503
Maintainer: sunqian1117
Description: LuCI Support for Srun Authentication
```

---

## 📤 如何安装构建的 IPK 包

### 步骤 1：上传到路由器

**方法 A - 使用 SCP：**
```bash
scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
```

**方法 B - 使用 WinSCP（Windows）：**
1. 下载 [WinSCP](https://winscp.net/)
2. 连接到路由器（IP: 192.168.1.1，用户: root）
3. 上传文件到 `/tmp/` 目录

### 步骤 2：SSH 连接到路由器

```bash
ssh root@192.168.1.1
```

### 步骤 3：安装依赖和 IPK 包

```bash
# 更新包列表
opkg update

# 安装依赖
opkg install curl jsonfilter coreutils-base64 openssl-util

# 安装 IPK 包
cd /tmp
opkg install luci-app-srun_*.ipk
```

### 步骤 4：配置和使用

参考 [INSTALL.md](INSTALL.md) 中的配置说明。

---

## 🛠️ 高级：使用 OpenWrt SDK 构建

如果你需要为特定的 OpenWrt 版本或架构构建，可以使用官方 OpenWrt SDK。

### 1. 下载 OpenWrt SDK

访问 [OpenWrt Downloads](https://downloads.openwrt.org/)，选择你的 OpenWrt 版本和架构，下载对应的 SDK。

例如，对于 22.03.2，ramips/mt7621：
```bash
wget https://downloads.openwrt.org/releases/22.03.2/targets/ramips/mt7621/openwrt-sdk-22.03.2-ramips-mt7621_gcc-11.2.0_musl.Linux-x86_64.tar.xz
tar xf openwrt-sdk-*.tar.xz
cd openwrt-sdk-*/
```

### 2. 复制包到 SDK

```bash
# 将 luci-app-srun 复制到 SDK 的 package 目录
cp -r /path/to/luci-app-srun package/
```

### 3. 编译

```bash
# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 选择包（如果需要）
make menuconfig
# 在 LuCI -> Applications 中选择 luci-app-srun

# 编译
make package/luci-app-srun/compile V=s
```

### 4. 获取编译结果

```bash
# 编译完成的 IPK 在：
ls bin/packages/*/luci/luci-app-srun_*.ipk
```

---

## 🤖 自动构建（GitHub Actions）

本项目已配置 GitHub Actions 自动构建。

### 触发自动构建

**方法 1 - 创建 Release：**
1. 在 GitHub 页面点击 "Releases"
2. 点击 "Create a new release"
3. 输入标签（如 `v1.0.0`）
4. 填写标题和描述
5. 点击 "Publish release"

GitHub Actions 会自动构建 IPK 包并上传到 Release。

**方法 2 - 推送 Tag：**
```bash
git tag v1.0.0
git push origin v1.0.0
```

**方法 3 - 手动触发：**
1. 访问 Actions 页面
2. 选择 "Build and Release IPK" workflow
3. 点击 "Run workflow"

---

## ❓ 常见问题

### Q: 构建时提示权限错误？
**A:** 确保 build-ipk.sh 有执行权限：
```bash
chmod +x build-ipk.sh
```

### Q: 构建在 Windows 上失败？
**A:** 请使用 WSL 或 Docker，不要直接在 Windows 命令行中运行 shell 脚本。

### Q: 如何修改包的版本号？
**A:** 编辑 `build-ipk.sh`，修改这几行：
```bash
PKG_VERSION="1.0.0"
PKG_RELEASE="1"
```

### Q: 如何添加新的依赖？
**A:** 编辑 `build-ipk.sh`，在 control 文件的 Depends 行添加：
```bash
Depends: curl, jsonfilter, coreutils-base64, openssl-util, new-package
```

同时也要更新 `Makefile` 中的 LUCI_DEPENDS。

### Q: 构建的包可以在所有 OpenWrt 设备上使用吗？
**A:** 是的！本包的架构是 `all`，意味着它不包含特定架构的二进制文件，可以在所有 OpenWrt 设备上使用。

### Q: 如何清理构建文件？
**A:** 
```bash
rm -rf build/
rm *.ipk
```

---

## 📚 相关文档

- **[README.md](README.md)** - 项目概述
- **[INSTALL.md](INSTALL.md)** - 详细安装指南
- **[QUICKSTART.md](QUICKSTART.md)** - 快速开始
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - 贡献指南

---

## 💡 提示

1. **构建很快**：整个构建过程只需要几秒钟
2. **无需 root 权限**：构建过程不需要 root 权限，只在路由器上安装时需要
3. **可重复构建**：你可以多次运行构建脚本，每次都会清理之前的构建
4. **跨平台**：构建的 IPK 包可以在任何 OpenWrt 设备上使用

---

**如有问题，请在 [GitHub Issues](https://github.com/sunqian1117/luci-app-srun/issues) 提出！**
