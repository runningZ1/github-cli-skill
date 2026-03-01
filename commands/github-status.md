---
name: github-status
description: 通过自然语言查看 GitHub 综合状态（issue、PR、通知）
version: 1.0.0
argument-hint: [options]
allowed-tools: Bash(*)
---

# GitHub 综合状态技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 访问私有仓库
- `read:org` - 读取组织信息

## 支持的操作

### 1. 查看综合状态

```
/github-status [--org <org>] [--exclude <repo1,repo2>]
```

**示例：**
- `/github-status` - 查看综合状态
- `/github-status --org microsoft` - 查看组织内状态
- `/github-status --exclude cli/cli,cli/go-gh` - 排除特定仓库

### 2. 查看分配给用户的 Issue

```
/github-status issues
```

**示例：**
- `/github-status issues` - 查看分配的 issue

### 3. 查看审查请求

```
/github-status reviews
```

**示例：**
- `/github-status reviews` - 查看需要审查的 PR

### 4. 查看提及

```
/github-status mentions
```

**示例：**
- `/github-status mentions` - 查看被提及的通知

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **综合状态**: `gh status`
2. **组织状态**: `gh status --org <org>`
3. **排除仓库**: `gh status --exclude <repos>`

## 输出格式化

- **分类输出**: 按类型分组显示（Issue、PR、审查、提及）
- **Markdown 格式**: 使用表格和链接
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 每日检查
```
# 查看今天的状态摘要
/github-status
```

### 场景 2: 组织视图
```
# 查看特定组织内的状态
/github-status --org microsoft
```

### 场景 3: 排除特定仓库
```
# 排除不关注的仓库
/github-status --exclude cli/cli,cli/go-gh
```

## 输出示例

```
╭────────────────────────────────────────────────────────────╮
│  GitHub Status Report                                      │
╰────────────────────────────────────────────────────────────╯

Assigned Issues (3)
┌─────────────────────────────────────────────────────────┐
│ #123  Fix login bug    cli/cli    high    2 days ago    │
│ #456  Update docs      cli/cli    medium  1 week ago    │
│ #789  Performance fix  cli/go-gh  low     3 days ago    │
└─────────────────────────────────────────────────────────┘

Review Requests (2)
┌─────────────────────────────────────────────────────────┐
│ #100  Add feature X    cli/cli    1 hour ago            │
│ #101  Fix typo         cli/go-gh  2 hours ago           │
└─────────────────────────────────────────────────────────┘

Mentions (1)
┌─────────────────────────────────────────────────────────┐
│ #50   Thanks for help  octocat/repo   30 min ago       │
└─────────────────────────────────────────────────────────┘
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **通知设置**: GitHub 通知设置会影响显示内容
2. **组织权限**: 需要组织权限才能查看组织状态
3. **速率限制**: 大量仓库可能触发 API 限制
