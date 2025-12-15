# 贡献指南 / Contributing Guide

感谢你对本项目的关注！欢迎任何形式的贡献。

Thank you for your interest in contributing! All forms of contributions are welcome.

[中文](#中文贡献指南) | [English](#english-contributing-guide)

---

## 中文贡献指南

### 如何贡献

#### 报告问题（Bug Report）

如果你发现了 bug 或有功能建议：

1. 在 [Issues](https://github.com/sunqian1117/luci-app-srun/issues) 页面搜索是否已有相关问题
2. 如果没有，创建新的 Issue，并提供：
   - 问题的详细描述
   - 复现步骤
   - 预期行为
   - 实际行为
   - OpenWrt 版本和路由器型号
   - 相关日志（`/var/log/srun.log`）

#### 提交代码（Pull Request）

1. **Fork 本仓库**
   - 点击页面右上角的 "Fork" 按钮

2. **克隆你的 Fork**
   ```bash
   git clone https://github.com/your-username/luci-app-srun.git
   cd luci-app-srun
   ```

3. **创建新分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/your-bug-fix
   ```

4. **进行修改**
   - 保持代码风格一致
   - 添加必要的注释
   - 确保修改不会破坏现有功能

5. **测试你的修改**
   ```bash
   # 构建 IPK 包
   ./build-ipk.sh
   
   # 在 OpenWrt 设备上测试
   # 1. 上传到路由器
   # 2. 安装并测试
   # 3. 查看日志确认无错误
   ```

6. **提交修改**
   ```bash
   git add .
   git commit -m "feat: add new feature" # 使用语义化提交信息
   git push origin feature/your-feature-name
   ```

7. **创建 Pull Request**
   - 访问你的 Fork 页面
   - 点击 "New Pull Request"
   - 填写 PR 描述，说明你的修改内容

### 代码风格

#### Shell 脚本
- 使用 4 个空格缩进
- 函数名使用下划线分隔：`function_name()`
- 变量名使用小写和下划线：`variable_name`
- 添加必要的错误处理

#### Lua 代码
- 使用 4 个空格缩进
- 遵循 LuCI 的代码风格
- 函数名使用驼峰命名：`functionName()`

#### 配置文件
- 使用 UCI 配置格式
- 添加注释说明各选项的作用

### 提交信息规范

使用语义化提交信息（Semantic Commit Messages）：

- `feat:` - 新功能
- `fix:` - Bug 修复
- `docs:` - 文档更新
- `style:` - 代码格式调整（不影响功能）
- `refactor:` - 代码重构
- `test:` - 测试相关
- `chore:` - 构建/工具相关

示例：
```
feat: add support for multiple accounts
fix: resolve login failure on OpenWrt 22.03
docs: update installation guide
```

### 开发环境设置

#### 本地测试构建

```bash
# 克隆仓库
git clone https://github.com/sunqian1117/luci-app-srun.git
cd luci-app-srun

# 构建 IPK 包
./build-ipk.sh

# 检查构建结果
ls -lh *.ipk
```

#### 使用 Docker 测试

```bash
# 启动 OpenWrt Docker 容器进行测试
docker run -it --rm \
  -v $(pwd):/app \
  openwrt/rootfs:latest \
  /bin/sh
```

#### 在真实设备上测试

1. 构建 IPK 包
2. 上传到 OpenWrt 设备
3. 安装并测试
4. 查看日志确认无错误

### 项目结构说明

```
luci-app-srun/
├── .github/
│   └── workflows/          # GitHub Actions 工作流
├── root/                   # 系统文件
│   ├── usr/bin/           # 可执行脚本
│   ├── usr/lib/srun/      # 库文件
│   └── etc/               # 配置文件
├── luasrc/                # LuCI Web 界面
│   ├── controller/        # 控制器
│   ├── model/cbi/         # 配置界面模型
│   └── view/              # 视图模板
├── Makefile               # OpenWrt 构建文件
├── build-ipk.sh           # IPK 构建脚本
├── README.md              # 项目说明
├── INSTALL.md             # 安装指南
├── QUICKSTART.md          # 快速开始
└── CONTRIBUTING.md        # 本文件
```

### 开发注意事项

1. **兼容性**
   - 确保代码兼容 OpenWrt 19.07+
   - 测试不同版本的兼容性

2. **依赖管理**
   - 最小化外部依赖
   - 在 Makefile 中明确声明所有依赖

3. **错误处理**
   - 添加适当的错误检查
   - 提供有用的错误信息
   - 记录错误到日志文件

4. **日志记录**
   - 使用统一的日志格式
   - 记录关键操作和错误
   - 避免记录敏感信息（如密码）

5. **安全性**
   - 不在日志中记录密码
   - 正确处理用户输入
   - 使用安全的加密方法

### 测试清单

在提交 PR 之前，请确保：

- [ ] 代码可以成功构建 IPK 包
- [ ] 在至少一个 OpenWrt 设备上测试通过
- [ ] 更新了相关文档
- [ ] 添加了必要的注释
- [ ] 遵循代码风格规范
- [ ] 提交信息清晰明确
- [ ] 无新的编译警告或错误

---

## English Contributing Guide

### How to Contribute

#### Report Issues

If you find a bug or have a feature suggestion:

1. Search [Issues](https://github.com/sunqian1117/luci-app-srun/issues) first
2. Create a new issue with:
   - Detailed description
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - OpenWrt version and router model
   - Relevant logs

#### Submit Code

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/luci-app-srun.git
   cd luci-app-srun
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make changes**
   - Keep code style consistent
   - Add necessary comments
   - Ensure no breaking changes

5. **Test your changes**
   ```bash
   ./build-ipk.sh
   # Test on actual OpenWrt device
   ```

6. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   git push origin feature/your-feature-name
   ```

7. **Create Pull Request**
   - Visit your fork on GitHub
   - Click "New Pull Request"
   - Fill in PR description

### Code Style

- **Shell**: 4 spaces, snake_case functions
- **Lua**: 4 spaces, camelCase functions
- Add comments for complex logic
- Include error handling

### Commit Message Format

Use semantic commit messages:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Code formatting
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Build/tools

### Testing Checklist

Before submitting PR:

- [ ] IPK builds successfully
- [ ] Tested on OpenWrt device
- [ ] Documentation updated
- [ ] Code comments added
- [ ] Style guidelines followed
- [ ] Clear commit messages
- [ ] No new warnings/errors

---

## 许可证 / License

贡献到本项目的代码将使用 GPL-2.0 许可证。

Code contributed to this project will be licensed under GPL-2.0.

---

## 联系方式 / Contact

- GitHub Issues: https://github.com/sunqian1117/luci-app-srun/issues
- Pull Requests: https://github.com/sunqian1117/luci-app-srun/pulls

感谢你的贡献！/ Thank you for contributing!
