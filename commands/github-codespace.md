---
name: github-codespace
description: 通过自然语言管理 GitHub Codespaces（创建、连接、管理）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub Codespaces 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 访问私有仓库

## 支持的操作

### 1. 列出 Codespaces

```
/github-codespace list [--limit <n>]
```

**示例：**
- `/github-codespace list` - 列出所有 codespaces
- `/github-codespace list --limit 10` - 列出前 10 个

### 2. 创建 Codespace

```
/github-codespace create [--repo <repo>] [--branch <branch>] [--machine <type>]
```

**示例：**
- `/github-codespace create` - 创建当前仓库的 codespace
- `/github-codespace create --repo owner/repo --branch main` - 创建指定仓库的 codespace

### 3. 查看 Codespace

```
/github-codespace view <codespace-name>
```

**示例：**
- `/github-codespace view funny-bassoon-abc123` - 查看 codespace 详情

### 4. 编辑 Codespace

```
/github-codespace edit <codespace-name> [--display-name <name>]
```

**示例：**
- `/github-codespace edit funny-bassoon-abc123 --display-name "My Dev"`

### 5. 删除 Codespace

```
/github-codespace delete <codespace-name>
```

**示例：**
- `/github-codespace delete funny-bassoon-abc123` - 删除 codespace

### 6. 连接 Codespace

```
/github-codespace ssh <codespace-name> [--command <cmd>]
```

**示例：**
- `/github-codespace ssh funny-bassoon-abc123` - SSH 连接
- `/github-codespace ssh funny-bassoon-abc123 --command "ls -la"` - 执行命令

### 7. 在 VS Code 中打开

```
/github-codespace code <codespace-name>
```

**示例：**
- `/github-codespace code funny-bassoon-abc123` - 在 VS Code 中打开

### 8. 查看日志

```
/github-codespace logs <codespace-name>
```

**示例：**
- `/github-codespace logs funny-bassoon-abc123` - 查看日志

### 9. 管理端口

```
/github-codespace ports <codespace-name>
```

**示例：**
- `/github-codespace ports funny-bassoon-abc123` - 列出端口

### 10. 停止 Codespace

```
/github-codespace stop <codespace-name>
```

**示例：**
- `/github-codespace stop funny-bassoon-abc123` - 停止 codespace

### 11. 重建 Codespace

```
/github-codespace rebuild <codespace-name>
```

**示例：**
- `/github-codespace rebuild funny-bassoon-abc123` - 重建 codespace

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出**: `gh codespace list --json <fields>`
2. **创建**: `gh codespace create`
3. **查看**: `gh codespace view --codespace <name>`
4. **编辑**: `gh codespace edit --codespace <name>`
5. **删除**: `gh codespace delete <name>`
6. **SSH**: `gh codespace ssh --codespace <name>`
7. **Code**: `gh codespace code --codespace <name>`
8. **Logs**: `gh codespace logs --codespace <name>`
9. **Ports**: `gh codespace ports --codespace <name>`
10. **Stop**: `gh codespace stop --codespace <name>`
11. **Rebuild**: `gh codespace rebuild --codespace <name>`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、仓库、状态、创建时间
- **详情输出**: 显示完整信息
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 创建开发环境
```
# 创建当前仓库的 codespace
/github-codespace create

# 创建指定分支的 codespace
/github-codespace create --repo owner/repo --branch feature
```

### 场景 2: 管理工作
```
# 列出所有 codespaces
/github-codespace list

# 查看特定 codespace
/github-codespace view funny-bassoon-abc123
```

### 场景 3: 连接开发
```
# VS Code 中打开
/github-codespace code funny-bassoon-abc123

# SSH 连接
/github-codespace ssh funny-bassoon-abc123
```

### 场景 4: 清理
```
# 删除不用的 codespace
/github-codespace delete funny-bassoon-abc123

# 停止 codespace 节省配额
/github-codespace stop funny-bassoon-abc123
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `code` - VS Code CLI（可选）
- `ssh` - SSH 客户端（可选）

## 注意事项

1. **配额限制**: GitHub 账号有 codespace 配额限制
2. **计费**: 超出免费配额后会计费
3. **自动停止**: 闲置的 codespace 会自动停止
4. **数据持久化**: 个人目录数据会持久化
