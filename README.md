# LuCI App Srun - 深澜校园网认证

OpenWrt 平台的深澜（Srun）校园网认证客户端，支持自动登录、断线重连和 Web 界面配置。

## 📚 文档导航

- **[快速安装指南 (INSTALL_CN.md)](INSTALL_CN.md)** - 最简单的入门教程
- **[详细构建说明 (BUILD.md)](BUILD.md)** - 完整的构建和安装文档（中英双语）
- **[常见问题 (FAQ.md)](FAQ.md)** - 30+ 个常见问题解答
- **[安装流程图 (WORKFLOW.md)](WORKFLOW.md)** - 可视化安装流程
- **[项目结构 (STRUCTURE.md)](STRUCTURE.md)** - 文件结构和开发说明

## 功能特性

- ✅ 完整的深澜 Srun Portal 认证协议支持
- ✅ 自动登录和断线重连
- ✅ LuCI Web 界面配置
- ✅ 支持手动登录/注销
- ✅ 实时状态显示和日志查看
- ✅ 开机自动认证
- ✅ 网络热插拔自动认证

## 快速安装

### 方法一：离线安装包（推荐）⭐

**最简单的方式！** 在本地电脑生成 IPK 安装包，然后上传到路由器安装。

```bash
# 1. 在电脑上生成安装包
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
./build.sh

# 2. 将生成的 IPK 文件传输到路由器
scp bin/luci-app-srun_1.0.0-1_all.ipk root@192.168.1.1:/tmp/

# 3. 在路由器上安装
ssh root@192.168.1.1
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk

# 4. 配置并启动
vi /etc/config/srun  # 填写用户名密码
/etc/init.d/srun enable
/etc/init.d/srun start
```

**详细的构建和安装说明请查看：[BUILD.md](BUILD.md)** 📖

### 方法二：手动安装

如果你不想生成 IPK 包，可以直接复制文件（需要应用代码文件）：

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
```

## 构建安装包

### 生成 IPK 离线安装包

本项目提供了简单的构建脚本，可以在不需要完整 OpenWrt SDK 的情况下生成 IPK 安装包。

```bash
# 克隆仓库
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 运行构建脚本
chmod +x build.sh
./build.sh

# 生成的 IPK 文件位于 bin/ 目录
ls -lh bin/
```

生成的 `luci-app-srun_1.0.0-1_all.ipk` 文件可以：
- 📦 复制到 U 盘，离线安装
- 🌐 通过 SCP 传输到路由器
- 💻 通过 LuCI Web 界面上传

### 详细构建和安装指南

完整的构建和安装说明请参考：**[BUILD.md](BUILD.md)**

包括：
- ✅ 使用构建脚本生成 IPK 包
- ✅ 使用 OpenWrt SDK 编译
- ✅ 三种不同的安装方法
- ✅ 故障排除指南

## 使用说明

### 配置文件

编辑 `/etc/config/srun`：

```
config srun 'config'
    option enabled '1'
    option username '你的学号'
    option password '你的密码'
    option server_url 'http://a.b.c.d'  # 认证服务器地址
```

### 服务管理

```bash
# 启动服务
/etc/init.d/srun start

# 停止服务
/etc/init.d/srun stop

# 重启服务
/etc/init.d/srun restart

# 查看状态
/etc/init.d/srun status
```

### 手动认证

```bash
# 登录
srun-auth login

# 注销
srun-auth logout

# 查看状态
srun-auth status
```

## 常见问题

### 1. 找不到命令

确保脚本有执行权限：
```bash
chmod +x /usr/bin/srun-auth
chmod +x /usr/lib/srun/crypto.sh
```

### 2. 依赖缺失

安装必要的依赖：
```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

### 3. 查看日志

```bash
logread | grep srun
```

## 许可证

GPL-2.0

## 贡献

欢迎提交 Issue 和 Pull Request！
