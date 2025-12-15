# 常见问题解答 (FAQ)

## 构建相关

### Q1: 我需要什么工具来构建 IPK 包？

**A:** 根据你的操作系统：

**Linux / macOS:**
- Git
- Bash（通常已预装）
- ar 命令（通常已预装）
- tar 命令（通常已预装）

**Windows:**
- WSL (Windows Subsystem for Linux)
- 或者使用虚拟机/Docker

### Q2: 构建脚本在哪里运行？

**A:** 构建脚本在你的**本地电脑**上运行，不是在路由器上运行。

```bash
# 在你的电脑上执行
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun
./build.sh
```

### Q3: Windows 用户如何构建？

**A:** 有三种方法：

**方法 1：使用 WSL（推荐）**
```cmd
# 1. 安装 WSL（以管理员身份运行 PowerShell）
wsl --install

# 2. 重启电脑后，运行构建脚本
build-windows.bat
```

**方法 2：使用 Git Bash**
```bash
# 在 Git Bash 中运行
./build.sh
```

**方法 3：使用虚拟机**
- 安装 Ubuntu 虚拟机
- 在虚拟机中执行构建

### Q4: 提示 "ar: command not found" 怎么办？

**A:** 安装 binutils 包：

```bash
# Debian/Ubuntu
sudo apt install binutils

# CentOS/RHEL
sudo yum install binutils

# macOS (通常已有，如果没有)
xcode-select --install
```

### Q5: 构建后在哪里找到 IPK 文件？

**A:** 在 `bin/` 目录下：

```bash
ls -lh bin/
# 输出: luci-app-srun_1.0.0-1_all.ipk
```

---

## 安装相关

### Q6: 如何将 IPK 文件传输到路由器？

**A:** 有多种方法：

**方法 1：SCP（推荐）**
```bash
scp bin/luci-app-srun_1.0.0-1_all.ipk root@192.168.1.1:/tmp/
```

**方法 2：WinSCP（Windows 用户）**
1. 下载 WinSCP: https://winscp.net/
2. 连接到路由器
3. 拖拽文件到 `/tmp/` 目录

**方法 3：U 盘**
1. 复制 IPK 到 U 盘
2. 插入路由器 USB 口
3. 在路由器上挂载并安装

**方法 4：LuCI Web 界面**
1. 登录 LuCI (http://192.168.1.1)
2. System → Software → Upload Package

### Q7: 提示 "Cannot satisfy dependencies" 怎么办？

**A:** 需要先安装依赖包：

```bash
ssh root@192.168.1.1
opkg update
opkg install curl jsonfilter coreutils-base64 openssl-util
# 然后重新安装
opkg install /tmp/luci-app-srun_1.0.0-1_all.ipk
```

### Q8: 如何验证安装是否成功？

**A:** 运行以下检查：

```bash
# 检查文件是否存在
ls -l /usr/bin/srun-auth
ls -l /etc/init.d/srun

# 检查服务状态
/etc/init.d/srun status

# 检查 LuCI 菜单
# 在浏览器中访问路由器，查看 Services 菜单
```

### Q9: 安装后找不到 LuCI 界面？

**A:** 可能的原因和解决方法：

**原因 1：LuCI 缓存**
```bash
rm -rf /tmp/luci-*
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
# 清除浏览器缓存，重新登录
```

**原因 2：权限问题**
```bash
chmod +x /usr/lib/lua/luci/controller/srun.lua
```

**原因 3：代码文件未包含**
- 确保 `luasrc/` 目录存在并有内容
- 重新构建和安装

---

## 使用相关

### Q10: 如何配置账号密码？

**A:** 两种方法：

**方法 1：命令行（推荐）**
```bash
ssh root@192.168.1.1
vi /etc/config/srun

# 修改以下内容
config srun 'config'
    option enabled '1'
    option username '你的学号'
    option password '你的密码'
    option server_url 'http://认证服务器IP'
```

**方法 2：LuCI Web 界面**
- Services → Srun Auth
- 填写配置并保存

### Q11: 如何测试认证是否成功？

**A:** 使用以下命令测试：

```bash
# 手动登录
srun-auth login

# 查看日志
logread | grep srun

# 查看服务状态
/etc/init.d/srun status
```

### Q12: 认证失败怎么办？

**A:** 检查步骤：

1. **验证配置文件**
   ```bash
   cat /etc/config/srun
   # 确认用户名、密码、服务器地址正确
   ```

2. **检查网络连接**
   ```bash
   ping -c 4 认证服务器IP
   ```

3. **查看详细日志**
   ```bash
   logread -f | grep srun
   # 然后运行 srun-auth login 查看错误信息
   ```

4. **手动测试认证接口**
   ```bash
   curl -v http://认证服务器IP
   ```

### Q13: 服务无法启动？

**A:** 诊断方法：

```bash
# 1. 检查脚本权限
ls -l /usr/bin/srun-auth
ls -l /etc/init.d/srun

# 2. 手动运行脚本
/usr/bin/srun-auth login

# 3. 查看错误日志
logread | tail -50

# 4. 检查依赖
opkg list-installed | grep -E 'curl|jsonfilter|base64|openssl'
```

### Q14: 如何设置开机自动认证？

**A:** 
```bash
/etc/init.d/srun enable
/etc/init.d/srun start

# 验证
/etc/init.d/srun enabled && echo "已启用" || echo "未启用"
```

### Q15: 如何查看实时日志？

**A:** 
```bash
# 实时查看日志
logread -f | grep srun

# 或者使用 LuCI 界面
# Services → Srun Auth → Logs (如果实现了此功能)
```

---

## 卸载和更新

### Q16: 如何卸载软件包？

**A:** 
```bash
# 停止服务
/etc/init.d/srun stop
/etc/init.d/srun disable

# 卸载软件包
opkg remove luci-app-srun

# 清理配置（可选）
rm -f /etc/config/srun
```

### Q17: 如何更新到新版本？

**A:** 
```bash
# 方法 1：直接升级
scp bin/luci-app-srun_1.1.0-1_all.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1
opkg upgrade /tmp/luci-app-srun_1.1.0-1_all.ipk

# 方法 2：卸载后重装（推荐）
opkg remove luci-app-srun
opkg install /tmp/luci-app-srun_1.1.0-1_all.ipk
```

### Q18: 更新会保留配置吗？

**A:** 
- 使用 `opkg upgrade`：**会保留**配置
- 使用 `opkg remove` 再 `install`：需要**手动备份**配置

备份配置：
```bash
cp /etc/config/srun /tmp/srun.backup
# 重装后恢复
cp /tmp/srun.backup /etc/config/srun
```

---

## 故障排除

### Q19: 提示 "package architecture (all) does not match system"？

**A:** 这通常不是问题，`all` 架构表示通用包。如果确实无法安装，运行：

```bash
opkg install --force-architecture /tmp/luci-app-srun_1.0.0-1_all.ipk
```

### Q20: 如何重置所有设置？

**A:** 
```bash
# 停止服务
/etc/init.d/srun stop

# 删除配置
rm -f /etc/config/srun

# 重新启动服务（会使用默认配置）
/etc/init.d/srun start

# 手动配置
vi /etc/config/srun
```

### Q21: IPK 包能在不同的路由器上使用吗？

**A:** 
- ✅ **可以**！这个包使用 `all` 架构，适用于所有 OpenWrt 设备
- ✅ 只要 OpenWrt 版本支持需要的依赖包即可
- ✅ 理论上兼容 OpenWrt 19.07+ 所有版本

### Q22: 可以同时安装多个版本吗？

**A:** 
- ❌ **不可以**。opkg 一次只能安装一个版本
- 如需测试新版本，建议：
  1. 备份配置
  2. 卸载旧版本
  3. 安装新版本
  4. 恢复配置

---

## 开发相关

### Q23: 如何修改代码？

**A:** 
1. 修改 `root/` 或 `luasrc/` 目录下的文件
2. 运行 `./build.sh` 重新生成 IPK
3. 传输到路由器并重新安装
4. 测试修改

### Q24: 如何添加新功能？

**A:** 
1. 在 `root/usr/lib/srun/` 添加新的脚本
2. 在 `luasrc/` 添加 LuCI 界面支持
3. 更新 `Makefile` 中的版本号
4. 重新构建测试

### Q25: 如何调试脚本？

**A:** 
```bash
# 1. 开启 Bash 调试模式
bash -x /usr/bin/srun-auth login

# 2. 添加调试输出
# 在脚本中添加
echo "DEBUG: variable=$variable" >> /tmp/srun-debug.log

# 3. 查看系统调用
strace /usr/bin/srun-auth login 2>&1 | tee /tmp/strace.log
```

---

## 其他问题

### Q26: 这个包安全吗？

**A:** 
- ✅ 开源代码，可以审查
- ✅ 不会收集或上传个人信息
- ✅ 密码存储在本地路由器
- ⚠️ 建议定期更新

### Q27: 支持哪些 OpenWrt 版本？

**A:** 
- ✅ OpenWrt 19.07+
- ✅ OpenWrt 21.02+
- ✅ OpenWrt 22.03+
- ✅ OpenWrt 23.05+ (推荐)

### Q28: 如何获取帮助？

**A:** 
- 📖 查看文档：README.md, BUILD.md, INSTALL_CN.md
- 🐛 提交 Issue：https://github.com/sunqian1117/luci-app-srun/issues
- 💬 社区讨论：在 Issue 中提问

### Q29: 可以商业使用吗？

**A:** 
- ✅ 可以，遵循 GPL-2.0 许可证
- ✅ 允许修改和分发
- ⚠️ 需要开源修改后的代码
- ⚠️ 保留原作者信息

### Q30: 如何贡献代码？

**A:** 
1. Fork 项目
2. 创建新分支
3. 提交改进
4. 发起 Pull Request
5. 等待审核

---

## 还有问题？

如果这里没有你的问题，请：
1. 查看 [BUILD.md](BUILD.md) 获取详细文档
2. 查看 [GitHub Issues](https://github.com/sunqian1117/luci-app-srun/issues) 搜索类似问题
3. 创建新的 Issue 描述你的问题

**提问时请提供：**
- OpenWrt 版本
- 路由器型号
- 错误信息或日志
- 已尝试的解决方法
