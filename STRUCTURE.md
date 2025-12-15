# 项目文件结构说明

## 当前构建系统文件

```
luci-app-srun/
├── README.md           # 项目说明文档
├── BUILD.md           # 详细构建和安装指南（中英双语）
├── INSTALL_CN.md      # 快速安装指南（中文）
├── STRUCTURE.md       # 本文件，项目结构说明
├── Makefile           # OpenWrt SDK 编译用 Makefile
├── build.sh           # 独立构建脚本（不需要 SDK）
├── .gitignore         # Git 忽略文件配置
└── bin/               # 构建产物目录（被忽略）
    └── luci-app-srun_1.0.0-1_all.ipk
```

## 应用代码文件结构（待添加）

要构建一个完整的 OpenWrt 软件包，你需要添加以下目录结构：

```
luci-app-srun/
├── root/                          # 系统文件（安装到 / 根目录）
│   ├── etc/
│   │   ├── config/
│   │   │   └── srun              # UCI 配置文件
│   │   ├── init.d/
│   │   │   └── srun              # 服务启动脚本
│   │   ├── hotplug.d/
│   │   │   └── iface/
│   │   │       └── 99-srun       # 网络热插拔脚本
│   │   └── uci-defaults/
│   │       └── luci-srun         # UCI 默认配置
│   └── usr/
│       ├── bin/
│       │   └── srun-auth         # 主认证脚本
│       └── lib/
│           └── srun/
│               ├── crypto.sh     # 加密库
│               ├── common.sh     # 通用函数库
│               └── api.sh        # API 接口库
│
└── luasrc/                       # LuCI 界面文件
    ├── controller/
    │   └── srun.lua              # 控制器
    ├── model/
    │   └── cbi/
    │       └── srun.lua          # 配置界面
    └── view/
        └── srun/
            ├── status.htm        # 状态页面
            └── log.htm           # 日志页面
```

## 文件说明

### root/ 目录下的文件

#### `/etc/config/srun`
UCI 配置文件，示例：

```
config srun 'config'
    option enabled '1'
    option username ''
    option password ''
    option server_url ''
    option auto_login '1'
    option check_interval '60'
```

#### `/etc/init.d/srun`
服务启动脚本，需要：
- `start()` - 启动服务
- `stop()` - 停止服务
- `restart()` - 重启服务
- `status()` - 查看状态

#### `/usr/bin/srun-auth`
主认证脚本，提供命令：
- `srun-auth login` - 登录
- `srun-auth logout` - 注销
- `srun-auth status` - 查看状态

### luasrc/ 目录下的文件

#### `controller/srun.lua`
定义路由和权限：

```lua
module("luci.controller.srun", package.seeall)

function index()
    entry({"admin", "services", "srun"}, cbi("srun"), _("Srun Auth"), 60)
    entry({"admin", "services", "srun", "status"}, call("action_status"))
end
```

#### `model/cbi/srun.lua`
配置界面定义：

```lua
m = Map("srun", translate("Srun Authentication"))

s = m:section(TypedSection, "srun", "")
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Enable"))
username = s:option(Value, "username", translate("Username"))
password = s:option(Value, "password", translate("Password"))
password.password = true

return m
```

## 如何使用

### 1. 添加应用代码

将你的应用代码按照上述结构放置在 `root/` 和 `luasrc/` 目录下。

### 2. 构建 IPK 包

```bash
./build.sh
```

构建脚本会自动：
1. 扫描 `root/` 和 `luasrc/` 目录
2. 创建正确的目录结构
3. 设置执行权限
4. 生成 IPK 安装包

### 3. 安装到 OpenWrt

```bash
scp bin/luci-app-srun_*.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1 'opkg install /tmp/luci-app-srun_*.ipk'
```

## 开发建议

### 最小可用版本

如果你刚开始开发，可以先创建一个最小可用版本：

1. **创建配置文件** (`root/etc/config/srun`)
2. **创建认证脚本** (`root/usr/bin/srun-auth`)
3. **创建服务脚本** (`root/etc/init.d/srun`)

然后逐步添加：
- LuCI Web 界面
- 自动重连功能
- 日志功能
- 热插拔支持

### 测试流程

1. 在开发机上编辑代码
2. 运行 `./build.sh` 生成 IPK
3. 传输到测试路由器
4. 卸载旧版本：`opkg remove luci-app-srun`
5. 安装新版本：`opkg install /tmp/luci-app-srun_*.ipk`
6. 测试功能
7. 查看日志：`logread | grep srun`

### 权限管理

确保脚本有正确的执行权限：

```bash
chmod +x root/usr/bin/srun-auth
chmod +x root/etc/init.d/srun
chmod +x root/usr/lib/srun/*.sh
```

`build.sh` 脚本会自动处理这些权限。

## 参考资源

- [OpenWrt Package Guidelines](https://openwrt.org/docs/guide-developer/packages)
- [LuCI Development Guide](https://github.com/openwrt/luci/wiki)
- [UCI Configuration System](https://openwrt.org/docs/guide-user/base-system/uci)
- [Init Scripts](https://openwrt.org/docs/techref/initscripts)

## 示例项目

可以参考其他 LuCI 应用的结构：
- [luci-app-shadowsocks](https://github.com/shadowsocks/luci-app-shadowsocks)
- [luci-app-watchcat](https://github.com/openwrt/packages/tree/master/utils/watchcat)
- [luci-app-acme](https://github.com/openwrt/luci/tree/master/applications/luci-app-acme)
