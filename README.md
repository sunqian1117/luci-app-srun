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
- ✅ 支持离线安装（IPK 包）

## 安装方法

### 📦 方法一：使用 IPK 包安装（推荐，最简单）

这是最简单的安装方法，适合所有用户。详细步骤请参考：**[完整安装指南 INSTALL.md](INSTALL.md)**

**快速步骤：**

1. **下载 IPK 包**
   - 从 [Releases](https://github.com/sunqian1117/luci-app-srun/releases) 页面下载最新的 `luci-app-srun_x.x.x-x_all.ipk`

2. **上传到路由器**
   ```bash
   scp luci-app-srun_*.ipk root@192.168.1.1:/tmp/
   ```

3. **SSH 连接并安装**
   ```bash
   ssh root@192.168.1.1
   opkg update
   opkg install curl jsonfilter coreutils-base64 openssl-util
   cd /tmp
   opkg install luci-app-srun_*.ipk
   ```

4. **配置和启动**
   - 在 Web 界面进入"服务" -> "Srun 认证"进行配置
   - 或编辑 `/etc/config/srun` 文件

### 🔨 方法二：自己构建 IPK 包

如果你想自己构建安装包：

```bash
# Linux 或 Mac 系统
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
./build-ipk.sh

# 构建完成后，会生成 luci-app-srun_*.ipk 文件
# 然后按方法一的步骤 2-4 进行安装
```

**Windows 用户**：请参考 [INSTALL.md](INSTALL.md) 中的详细说明（使用 WSL 或 Docker）。

### 🛠️ 方法三：手动安装（开发者）

```bash
# 1. 连接到路由器
ssh root@192.168.1.1

# 2. 安装依赖
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util

# 3. 下载源码
cd /tmp
wget https://github.com/sunqian1117/luci-app-srun/archive/refs/heads/main.zip
unzip main.zip
cd luci-app-srun-main

# 4. 安装
chmod +x root/usr/bin/srun-auth
chmod +x root/usr/lib/srun/crypto.sh
chmod +x root/etc/init.d/srun
chmod +x root/etc/hotplug.d/iface/99-srun
cp -r root/* /
cp -r luasrc/* /usr/lib/lua/luci/

# 5. 启用服务
/etc/init.d/srun enable
/etc/init.d/srun start
```

## 📖 详细文档

- **[完整安装指南 (INSTALL.md)](INSTALL.md)** - 包含三种安装方法的详细步骤
  - 使用 IPK 包安装（推荐）
  - 自己构建 IPK 包（Windows/Linux/Mac）
  - 手动安装
  - 详细的配置说明
  - 常见问题和故障排查

## 配置说明

### Web 界面配置（推荐）

1. 浏览器访问路由器：http://192.168.1.1
2. 登录后进入"服务" -> "Srun 认证"
3. 填写配置信息并保存

### 命令行配置

编辑配置文件：
```bash
vi /etc/config/srun
```

配置示例：
```
config basic 'basic'
    option enabled '1'
    option server 'http://10.0.0.1'
    option username '20210001'
    option password 'yourpassword'
    option interface 'wan'
    option acid '1'
    option auto_login '1'
```

重启服务：
```bash
/etc/init.d/srun restart
```

## 使用说明

### 命令行操作

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

### 服务管理

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

## 文件结构

```
luci-app-srun/
├── Makefile                          # OpenWrt 包构建文件
├── build-ipk.sh                      # IPK 包构建脚本
├── README.md                         # 项目说明（本文件）
├── INSTALL.md                        # 详细安装指南
├── root/                             # 系统文件
│   ├── usr/
│   │   ├── bin/
│   │   │   └── srun-auth            # 认证主程序
│   │   └── lib/
│   │       └── srun/
│   │           └── crypto.sh        # 加密函数库
│   └── etc/
│       ├── config/
│       │   └── srun                 # 配置文件
│       ├── init.d/
│       │   └── srun                 # 服务启动脚本
│       └── hotplug.d/
│           └── iface/
│               └── 99-srun          # 网络热插拔脚本
└── luasrc/                          # LuCI Web 界面
    ├── controller/
    │   └── srun.lua                 # 控制器
    ├── model/
    │   └── cbi/
    │       └── srun.lua             # 配置界面
    └── view/
        └── srun/
            └── status.htm           # 状态显示页面
```

## 常见问题

### 1. 安装后在 Web 界面找不到 Srun 选项？

清除缓存并重启 Web 服务：
```bash
rm -rf /tmp/luci-*
/etc/init.d/uhttpd restart
```

### 2. 认证失败怎么办？

查看日志获取详细错误信息：
```bash
srun-auth login
tail -20 /var/log/srun.log
```

### 3. 如何获取学校的 Srun 服务器地址？

- 咨询学校网络中心
- 在连接校园网时使用抓包工具获取
- 通常格式为：`http://10.x.x.x` 或 `http://auth.university.edu.cn`

### 4. 支持哪些 OpenWrt 版本？

支持 OpenWrt 19.07 及以上版本，包括 21.02、22.03 和最新的 23.05。

更多问题请查看 [INSTALL.md](INSTALL.md) 中的故障排查章节。

## 依赖项

- curl - HTTP 请求工具
- jsonfilter - JSON 解析工具
- coreutils-base64 - Base64 编码工具
- openssl-util - 加密工具

## 兼容性

- ✅ OpenWrt 19.07+
- ✅ OpenWrt 21.02
- ✅ OpenWrt 22.03
- ✅ OpenWrt 23.05
- ✅ 所有架构（all）

## 开发

### 构建 IPK 包

```bash
./build-ipk.sh
```

### 使用 OpenWrt SDK 构建

如果你有 OpenWrt SDK：

```bash
# 将本项目复制到 SDK 的 package 目录
cp -r luci-app-srun /path/to/openwrt-sdk/package/

# 编译
cd /path/to/openwrt-sdk
make package/luci-app-srun/compile
```

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

GPL-2.0 License

## 致谢

感谢所有为 OpenWrt 和 LuCI 项目做出贡献的开发者。

## 支持

如有问题或建议，请在 [GitHub Issues](https://github.com/sunqian1117/luci-app-srun/issues) 中提出
