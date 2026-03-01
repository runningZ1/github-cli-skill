---
name: github-auth
description: 通过自然语言管理 GitHub 认证（登录、登出、切换账号、查看状态）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub 认证管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

## 支持的操作

### 1. 登录

```
/github-auth login [--web] [--hostname <hostname>] [--git-protocol <https|ssh>]
```

**示例：**
- `/github-auth login` - 交互式登录
- `/github-auth login --web` - 使用浏览器登录
- `/github-auth login --hostname github.enterprise.com` - 登录企业版

### 2. 登出

```
/github-auth logout [--hostname <hostname>]
```

**示例：**
- `/github-auth logout` - 登出当前账号
- `/github-auth logout --hostname github.enterprise.com` - 登出指定主机

### 3. 查看认证状态

```
/github-auth status
```

**示例：**
- `/github-auth status` - 查看所有账号状态
- `/github-auth status --hostname github.com` - 查看指定主机状态

### 4. 刷新认证

```
/github-auth refresh [--scope <scope>]
```

**示例：**
- `/github-auth refresh` - 刷新认证
- `/github-auth refresh --scope workflow` - 添加 workflow 权限

### 5. 切换账号

```
/github-auth switch
```

**示例：**
- `/github-auth switch` - 交互式切换账号

### 6. 获取 Token

```
/github-auth token
```

**示例：**
- `/github-auth token` - 打印当前 token
- `/github-auth token --hostname github.com` - 打印指定主机 token

### 7. 设置 Git

```
/github-auth setup-git
```

**示例：**
- `/github-auth setup-git` - 配置 git 认证

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **登录**: `gh auth login`
2. **登出**: `gh auth logout`
3. **状态**: `gh auth status`
4. **刷新**: `gh auth refresh`
5. **切换**: `gh auth switch`
6. **Token**: `gh auth token`
7. **Git 设置**: `gh auth setup-git`

## 输出格式化

- **状态输出**: Markdown 表格显示账号、主机、权限、状态
- **Token 输出**: 仅显示 token 值（注意保密）
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 首次登录
```
# 交互式登录
/github-auth login

# 使用浏览器登录（推荐）
/github-auth login --web
```

### 场景 2: 多账号管理
```
# 查看当前所有账号
/github-auth status

# 切换账号
/github-auth switch

# 登出特定账号
/github-auth logout --hostname github.com
```

### 场景 3: 添加权限
```
# 查看当前权限
/github-auth status

# 添加 workflow 权限
/github-auth refresh --scope workflow

# 添加多个权限
/github-auth refresh --scope workflow --scope project
```

### 场景 4: Git 集成
```
# 设置 git 认证
/github-auth setup-git
```

### 场景 5: 获取 Token
```
# 获取当前 token（用于脚本）
/github-auth token
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **Token 安全**: 不要分享 token
2. **权限范围**: 根据需要申请最小权限
3. **多账号**: 支持多个 GitHub 账号
4. **企业版**: 支持 GitHub Enterprise

## 所需 Scopes

| Scope | 用途 |
|-------|------|
| `repo` | 完整控制私有仓库 |
| `workflow` | 运行工作流 |
| `read:org` | 读取组织信息 |
| `gist` | 管理 Gist |
| `project` | 管理 Projects |
