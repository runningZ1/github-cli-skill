---
name: github-org
description: 通过自然语言管理 GitHub 组织（查看组织、团队列表）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub 组织管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `read:org` - 读取组织信息

## 支持的操作

### 1. 列出组织

```
/github-org list [--user <username>] [--limit <n>]
```

**示例：**
- `/github-org list` - 列出当前用户所属组织
- `/github-org list --user octocat` - 列出指定用户的组织
- `/github-org list --limit 10` - 列出前 10 个组织

### 2. 查看组织详情

```
/github-org view <org>
```

**示例：**
- `/github-org view microsoft` - 查看微软组织
- `/github-org view cli` - 查看 CLI 组织

### 3. 列出团队成员

```
/github-org members <org> [--limit <n>]
```

**示例：**
- `/github-org members microsoft` - 列出微软成员
- `/github-org members cli --limit 10` - 列出前 10 个成员

### 4. 列出团队

```
/github-org teams <org>
```

**示例：**
- `/github-org teams microsoft` - 列出微软的团队

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出组织**: `gh org list --json <fields> --limit <n>`
2. **查看组织**: `gh api /orgs/<org> --json <fields>`
3. **列出成员**: `gh api /orgs/<org>/members --json <fields>`
4. **列出团队**: `gh api /orgs/<org>/teams --json <fields>`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、描述、成员数量
- **详情输出**: 显示组织信息、仓库数量、成员数量
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 查看所属组织
```
# 列出自己所属的组织
/github-org list
```

### 场景 2: 查看他人组织
```
# 查看用户所属组织
/github-org list --user octocat
```

### 场景 3: 查看组织详情
```
# 查看组织信息
/github-org view microsoft
```

### 场景 4: 查看团队成员
```
# 列出组织成员
/github-org members microsoft
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **权限**: 需要 `read:org` 权限
2. **隐私**: 私有组织信息仅对成员可见
3. **API 限制**: 受 GitHub API 速率限制
