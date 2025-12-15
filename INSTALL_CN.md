# 快速安装指南

## 第一步：在电脑上生成安装包

### 准备工作
- 一台 Linux 电脑或 macOS（Windows 用户可以使用 WSL）
- 安装了 Git 和 Bash

### 生成 IPK 安装包

1. **打开终端，克隆仓库**
   ```bash
   git clone https://github.com/sunqian1117/luci-app-srun.git
   cd luci-app-srun
   ```

2. **运行构建脚本**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **查看生成的安装包**
   ```bash
   ls -lh bin/
   ```
   
   你会看到：`luci-app-srun_1.0.0-1_all.ipk`

🎉 **安装包生成成功！** 这个 `.ipk` 文件就是可以在 OpenWrt 上安装的软件包。

---

## 第二步：将安装包传输到路由器

### 方法 A：使用 SCP（推荐）

如果你的电脑可以访问路由器：

```bash
scp bin/luci-app-srun_1.0.0-1_all.ipk root@192.168.1.1:/tmp/
```

> **注意：** 将 `192.168.1.1` 替换为你的路由器 IP 地址

### 方法 B：使用 U 盘

1. 将 `bin/luci-app-srun_1.0.0-1_all.ipk` 复制到 U 盘
2. 将 U 盘插入路由器的 USB 口
3. SSH 连接到路由器，找到 U 盘挂载点（通常在 `/mnt/` 下）

### 方法 C：使用 WinSCP（Windows 用户）

1. 下载并安装 [WinSCP](https://winscp.net/)
2. 连接到路由器（协议：SCP，主机：192.168.1.1，用户名：root）
3. 将 IPK 文件拖拽到 `/tmp/` 目录

---

## 第三步：在路由器上安装

### 1. SSH 连接到路由器

```bash
ssh root@192.168.1.1
```

输入 root 密码。

### 2. 安装软件包

```bash
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
```

如果提示依赖缺失，先安装依赖：

```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

然后重新安装：

```bash
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
```

### 3. 配置账号信息

编辑配置文件：

```bash
vi /etc/config/srun
```

填写你的校园网账号信息：

```
config srun 'config'
    option enabled '1'
    option username '你的学号'
    option password '你的密码'
    option server_url 'http://认证服务器地址'
```

保存退出（按 `ESC`，输入 `:wq`，按 `Enter`）。

### 4. 启动服务

```bash
/etc/init.d/srun enable
/etc/init.d/srun start
```

---

## 第四步：验证安装

### 检查服务状态

```bash
/etc/init.d/srun status
```

### 查看日志

```bash
logread | grep srun
```

### 手动测试认证

```bash
srun-auth login
```

### 在 Web 界面中查看

1. 打开浏览器，访问 `http://192.168.1.1`
2. 登录 LuCI 管理界面
3. 在 `Services`（服务）菜单下找到 `Srun Auth`

---

## 使用 LuCI Web 界面安装（可选）

如果你不想使用命令行，也可以通过 Web 界面安装：

1. **登录 LuCI**
   - 浏览器打开：`http://192.168.1.1`
   - 输入用户名和密码

2. **上传安装包**
   - 进入 `System`（系统） → `Software`（软件包）
   - 点击 `Upload Package...`（上传软件包...）标签
   - 选择 `luci-app-srun_1.0.0-1_all.ipk` 文件
   - 点击 `Upload`（上传）按钮
   - 等待上传完成后，点击 `Install`（安装）

3. **配置服务**
   - 进入 `Services`（服务） → `Srun Auth`（深澜认证）
   - 填写用户名、密码和服务器地址
   - 勾选 `Enable`（启用）
   - 点击 `Save & Apply`（保存并应用）

---

## 常见问题

### Q1: 提示 "Cannot satisfy dependencies"

**解决方法：** 先更新软件包列表并安装依赖

```bash
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
```

### Q2: 服务无法启动

**检查步骤：**

1. 确认配置文件正确：
   ```bash
   cat /etc/config/srun
   ```

2. 查看错误日志：
   ```bash
   logread | tail -50
   ```

3. 手动运行测试：
   ```bash
   /usr/bin/srun-auth login
   ```

### Q3: 找不到 `srun-auth` 命令

**解决方法：** 检查文件权限

```bash
chmod +x /usr/bin/srun-auth
ls -l /usr/bin/srun-auth
```

### Q4: 如何卸载？

```bash
/etc/init.d/srun stop
/etc/init.d/srun disable
opkg remove luci-app-srun
```

---

## 需要帮助？

- 查看详细文档：[BUILD.md](BUILD.md)
- 查看项目主页：[README.md](README.md)
- 提交 Issue：[GitHub Issues](https://github.com/sunqian1117/luci-app-srun/issues)

---

**祝你使用愉快！** 🎉
