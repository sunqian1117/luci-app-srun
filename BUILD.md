# 构建和安装指南 / Build and Installation Guide

[English](#english) | [中文](#chinese)

---

<a name="chinese"></a>
## 中文指南

### 一、生成离线安装包

#### 方法 1：使用构建脚本（推荐，最简单）

这种方法不需要 OpenWrt SDK，可以在任何 Linux 系统或 macOS 上运行。

**步骤：**

1. **克隆仓库到本地电脑**
   ```bash
   git clone https://github.com/sunqian1117/luci-app-srun.git
   cd luci-app-srun
   ```

2. **运行构建脚本**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **获取生成的安装包**
   
   构建成功后，安装包将在 `bin/` 目录下：
   ```
   bin/luci-app-srun_1.0.0-1_all.ipk
   ```

   这个 `.ipk` 文件就是可以离线安装的 OpenWrt 软件包！

#### 方法 2：使用 OpenWrt SDK（完整编译）

如果你想使用官方的 OpenWrt 构建系统，需要先下载 OpenWrt SDK。

**步骤：**

1. **下载 OpenWrt SDK**
   
   从 [OpenWrt 下载页面](https://downloads.openwrt.org/releases/) 下载适合你路由器架构的 SDK。
   
   例如，对于 x86_64 架构：
   ```bash
   wget https://downloads.openwrt.org/releases/23.05.2/targets/x86/64/openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz
   tar xf openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz
   cd openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64
   ```

2. **复制软件包到 SDK**
   ```bash
   mkdir -p package/luci-app-srun
   cp -r /path/to/luci-app-srun/* package/luci-app-srun/
   ```

3. **更新 feeds**
   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   ```

4. **编译软件包**
   ```bash
   make package/luci-app-srun/compile V=s
   ```

5. **查找生成的安装包**
   ```bash
   find bin/ -name "luci-app-srun*.ipk"
   ```

### 二、安装到 OpenWrt 路由器

#### 准备工作

1. **确保路由器可以访问**
   - 路由器 IP 地址（通常是 192.168.1.1 或 192.168.0.1）
   - SSH 访问已启用
   - root 密码

2. **准备好生成的 IPK 文件**
   - 文件名类似：`luci-app-srun_1.0.0-1_all.ipk`

#### 安装步骤

**方法 1：使用 SCP + SSH（推荐）**

1. **将 IPK 文件传输到路由器**
   ```bash
   scp bin/luci-app-srun_1.0.0-1_all.ipk root@192.168.1.1:/tmp/
   ```
   
   输入路由器的 root 密码。

2. **SSH 连接到路由器**
   ```bash
   ssh root@192.168.1.1
   ```

3. **安装软件包**
   ```bash
   opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
   ```

4. **配置和启动服务**
   ```bash
   # 编辑配置文件，填写你的校园网账号密码
   vi /etc/config/srun
   
   # 启用并启动服务
   /etc/init.d/srun enable
   /etc/init.d/srun start
   ```

**方法 2：使用 LuCI Web 界面**

1. **登录 LuCI 界面**
   
   在浏览器中打开：`http://192.168.1.1`

2. **上传安装包**
   - 进入 `System（系统）` → `Software（软件包）`
   - 点击 `Upload Package...（上传软件包...）` 标签
   - 选择 IPK 文件并上传
   - 点击 `Install（安装）`

3. **配置服务**
   - 进入 `Services（服务）` → `Srun Auth（深澜认证）`
   - 填写配置信息
   - 启用并启动服务

**方法 3：手动复制文件（不推荐，但可行）**

如果以上方法都不可行，可以手动解压 IPK 并复制文件：

```bash
# 在电脑上解压 IPK
mkdir -p /tmp/srun-extract
cd /tmp/srun-extract
ar x /path/to/luci-app-srun_1.0.0-1_all.ipk
tar xzf data.tar.gz

# 使用 SCP 复制所有文件到路由器
scp -r etc root@192.168.1.1:/
scp -r usr root@192.168.1.1:/

# 在路由器上设置权限
ssh root@192.168.1.1 "chmod +x /usr/bin/srun-auth && chmod +x /etc/init.d/srun"
```

### 三、验证安装

1. **检查服务状态**
   ```bash
   /etc/init.d/srun status
   ```

2. **查看日志**
   ```bash
   logread | grep srun
   ```

3. **测试认证**
   ```bash
   srun-auth login
   ```

4. **在 LuCI 界面中查看**
   
   打开浏览器访问路由器的 LuCI 界面，应该能在 `Services` 菜单下看到 `Srun Auth` 选项。

### 四、故障排除

#### 依赖问题

如果安装时提示依赖缺失，先安装依赖：

```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

然后重新安装软件包。

#### 服务无法启动

1. 检查配置文件是否正确：
   ```bash
   cat /etc/config/srun
   ```

2. 查看错误日志：
   ```bash
   logread | tail -50
   ```

3. 手动运行认证脚本测试：
   ```bash
   /usr/bin/srun-auth login
   ```

#### 重新安装

```bash
# 卸载
opkg remove luci-app-srun

# 重新安装
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
```

---

<a name="english"></a>
## English Guide

### 1. Generate Offline Installation Package

#### Method 1: Using Build Script (Recommended, Easiest)

This method doesn't require the OpenWrt SDK and can run on any Linux system or macOS.

**Steps:**

1. **Clone the repository to your computer**
   ```bash
   git clone https://github.com/sunqian1117/luci-app-srun.git
   cd luci-app-srun
   ```

2. **Run the build script**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **Get the generated package**
   
   After successful build, the package will be in the `bin/` directory:
   ```
   bin/luci-app-srun_1.0.0-1_all.ipk
   ```

   This `.ipk` file is the offline installable OpenWrt package!

#### Method 2: Using OpenWrt SDK (Full Build)

If you want to use the official OpenWrt build system, you need to download the OpenWrt SDK first.

**Steps:**

1. **Download OpenWrt SDK**
   
   Download the SDK for your router architecture from [OpenWrt Downloads](https://downloads.openwrt.org/releases/).
   
   For example, for x86_64 architecture:
   ```bash
   wget https://downloads.openwrt.org/releases/23.05.2/targets/x86/64/openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz
   tar xf openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64.tar.xz
   cd openwrt-sdk-23.05.2-x86-64_gcc-12.3.0_musl.Linux-x86_64
   ```

2. **Copy package to SDK**
   ```bash
   mkdir -p package/luci-app-srun
   cp -r /path/to/luci-app-srun/* package/luci-app-srun/
   ```

3. **Update feeds**
   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   ```

4. **Compile the package**
   ```bash
   make package/luci-app-srun/compile V=s
   ```

5. **Find the generated package**
   ```bash
   find bin/ -name "luci-app-srun*.ipk"
   ```

### 2. Install on OpenWrt Router

#### Prerequisites

1. **Ensure router is accessible**
   - Router IP address (usually 192.168.1.1 or 192.168.0.1)
   - SSH access enabled
   - root password

2. **Have the generated IPK file ready**
   - Filename like: `luci-app-srun_1.0.0-1_all.ipk`

#### Installation Steps

**Method 1: Using SCP + SSH (Recommended)**

1. **Transfer IPK file to router**
   ```bash
   scp bin/luci-app-srun_1.0.0-1_all.ipk root@192.168.1.1:/tmp/
   ```
   
   Enter your router's root password.

2. **SSH to the router**
   ```bash
   ssh root@192.168.1.1
   ```

3. **Install the package**
   ```bash
   opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
   ```

4. **Configure and start service**
   ```bash
   # Edit config file with your credentials
   vi /etc/config/srun
   
   # Enable and start service
   /etc/init.d/srun enable
   /etc/init.d/srun start
   ```

**Method 2: Using LuCI Web Interface**

1. **Login to LuCI**
   
   Open in browser: `http://192.168.1.1`

2. **Upload package**
   - Go to `System` → `Software`
   - Click `Upload Package...` tab
   - Select the IPK file and upload
   - Click `Install`

3. **Configure service**
   - Go to `Services` → `Srun Auth`
   - Fill in configuration
   - Enable and start service

**Method 3: Manual File Copy (Not recommended, but works)**

If none of the above methods work, you can manually extract and copy files:

```bash
# Extract IPK on your computer
mkdir -p /tmp/srun-extract
cd /tmp/srun-extract
ar x /path/to/luci-app-srun_1.0.0-1_all.ipk
tar xzf data.tar.gz

# Copy files to router using SCP
scp -r etc root@192.168.1.1:/
scp -r usr root@192.168.1.1:/

# Set permissions on router
ssh root@192.168.1.1 "chmod +x /usr/bin/srun-auth && chmod +x /etc/init.d/srun"
```

### 3. Verify Installation

1. **Check service status**
   ```bash
   /etc/init.d/srun status
   ```

2. **View logs**
   ```bash
   logread | grep srun
   ```

3. **Test authentication**
   ```bash
   srun-auth login
   ```

4. **Check in LuCI**
   
   Open your router's LuCI interface, you should see `Srun Auth` under the `Services` menu.

### 4. Troubleshooting

#### Dependency Issues

If installation complains about missing dependencies, install them first:

```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

Then reinstall the package.

#### Service Won't Start

1. Check if config file is correct:
   ```bash
   cat /etc/config/srun
   ```

2. View error logs:
   ```bash
   logread | tail -50
   ```

3. Test auth script manually:
   ```bash
   /usr/bin/srun-auth login
   ```

#### Reinstall

```bash
# Remove
opkg remove luci-app-srun

# Reinstall
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
```
