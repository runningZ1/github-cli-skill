---
name: github-gpg-key
description: 通过自然语言管理 GitHub GPG 密钥（添加、查看、删除）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub GPG Key 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `write:gpg_key` - 管理 GPG 密钥

## 支持的操作

### 1. 列出 GPG 密钥

```
/github-gpg-key list
```

**示例：**
- `/github-gpg-key list` - 列出所有 GPG 密钥

### 2. 添加 GPG 密钥

```
/github-gpg-key add <key-file> [--title <title>]
```

**示例：**
- `/github-gpg-key add ~/gpg-key.asc --title "Work Key"`
- `/github-gpg-key add <(gpg --armor --export user@example.com) --title "Main Key"`

### 3. 删除 GPG 密钥

```
/github-gpg-key delete <key-id>
```

**示例：**
- `/github-gpg-key delete 123` - 删除指定 ID 的密钥

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出密钥**: `gh gpg-key list --json <fields>`
2. **添加密钥**: `gh gpg-key add <file> --title <title>`
3. **删除密钥**: `gh gpg-key delete <id>`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、密钥 ID、邮箱、创建时间
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
# 列出所有 GPG 密钥
/github-gpg-key list
```

### 场景 2: 添加新密钥
```
# 导出公钥
gpg --armor --export user@example.com > gpg-key.asc

# 添加到 GitHub
/github-gpg-key add gpg-key.asc --title "Main Key"
```

### 场景 3: 配置 git 使用 GPG
```
# 设置使用 GPG 签名
git config --global commit.gpgsign true
git config --global user.signingkey <key-id>
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `gpg` - GPG 工具

## 注意事项

1. **公钥**: 只上传公钥，不要上传私钥
2. **邮箱验证**: GPG 密钥的邮箱需要添加到 GitHub 账号
3. **签名提交**: 配置后可以签名 commit
