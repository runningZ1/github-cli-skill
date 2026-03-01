---
name: github-ssh-key
description: 通过自然语言管理 GitHub SSH 密钥（添加、查看、删除）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub SSH Key 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `write:public_key` - 管理 SSH 密钥

## 支持的操作

### 1. 列出 SSH 密钥

```
/github-ssh-key list
```

**示例：**
- `/github-ssh-key list` - 列出所有 SSH 密钥

### 2. 添加 SSH 密钥

```
/github-ssh-key add <key-file> [--title <title>]
```

**示例：**
- `/github-ssh-key add ~/.ssh/id_rsa.pub --title "Work Laptop"`
- `/github-ssh-key add ~/.ssh/id_ed25519.pub --title "Personal"`

### 3. 删除 SSH 密钥

```
/github-ssh-key delete <key-id>
```

**示例：**
- `/github-ssh-key delete 123` - 删除指定 ID 的密钥

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出密钥**: `gh ssh-key list --json <fields>`
2. **添加密钥**: `gh ssh-key add <file> --title <title>`
3. **删除密钥**: `gh ssh-key delete <id>`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、标题、指纹、创建时间
- **成功状态**: 显示操作结果
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 查看密钥
```
# 列出所有 SSH 密钥
/github-ssh-key list
```

### 场景 2: 添加新密钥
```
# 生成新密钥
ssh-keygen -t ed25519 -C "github@example.com"

# 添加到 GitHub
/github-ssh-key add ~/.ssh/id_ed25519.pub --title "New Laptop"
```

### 场景 3: 清理旧密钥
```
# 查看密钥
/github-ssh-key list

# 删除旧密钥
/github-ssh-key delete 123
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `ssh-keygen` - SSH 密钥生成工具

## 注意事项

1. **密钥类型**: 推荐 ED25519 或 RSA 4096
2. **唯一性**: 同一个密钥不能添加到多个账号
3. **安全**: 不要分享私钥
