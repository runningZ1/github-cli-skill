---
name: github-issue
description: 通过自然语言执行 GitHub Issue 相关操作（创建、查看、列表、分配、标签等）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Issue 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

## 支持的操作

### 1. 创建 Issue

```
/github-issue create --title "title" [--body "description"] [--label label] [--assignee user]
```

**示例：**
- `/github-issue create --title "Bug: Login fails with invalid credentials"`
- `/github-issue create --title "Feature: Add dark mode" --body "Description of the feature" --label enhancement --assignee octocat`

### 2. 查看 Issue

```
/github-issue view [issue-number] [--web]
```

**示例：**
- `/github-issue view` - 查看当前 Issue
- `/github-issue view 123` - 查看 Issue #123
- `/github-issue view 123 --web` - 在浏览器中打开 Issue

### 3. Issue 列表

```
/github-issue list [--state open|closed] [--author user] [--assignee user] [--label label] [--limit n]
```

**示例：**
- `/github-issue list` - 查看所有开放的 Issue
- `/github-issue list --state open --limit 10` - 查看 10 个开放的 Issue
- `/github-issue list --label bug --state open` - 查看所有开放的 bug
- `/github-issue list --assignee octocat` - 查看分配给 octocat 的 Issue

### 4. 分配 Issue

```
/github-issue edit [issue-number] --add-assignee user [--remove-assignee user]
```

**示例：**
- `/github-issue edit 123 --add-label bug --add-label priority-high`
- `/github-issue edit 123 --remove-label wontfix`

### 6. 评论 Issue

```
/github-issue comment [issue-number] --body "comment"
```

**示例：**
- `/github-issue comment 123 --body "I can reproduce this bug"`
- `/github-issue comment --body "This feature request is important"`

### 7. 更新 Issue

```
/github-issue edit [issue-number] [--title "title"] [--body "description"]
```

**示例：**
- `/github-issue edit 123 --title "Updated title"`
- `/github-issue edit 123 --body "Updated description with more details"`

### 8. 关闭/重新打开 Issue

```
/github-issue close [issue-number]
/github-issue reopen [issue-number]
```

**示例：**
- `/github-issue close 123` - 关闭 Issue #123
- `/github-issue reopen 123` - 重新打开 Issue #123

### 9. 转移 Issue

```
/github-issue transfer [issue-number] owner/repo
```

**示例：**
- `/github-issue transfer 123 octocat/new-repo` - 转移 Issue 到另一个仓库

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **创建 Issue**: `gh issue create --title <title> --body <body> --label <label> --assignee <user>`
2. **查看 Issue**: `gh issue view [<number>] --json <fields>`
3. **Issue 列表**: `gh issue list --state <state> --author <user> --assignee <user> --label <label> --limit <n> --json <fields>`
4. **分配/标签**: `gh issue edit [<number>] --add-assignee <user> --add-label <label>`
5. **评论 Issue**: `gh issue comment [<number>] --body <comment>`
6. **编辑 Issue**: `gh issue edit [<number>] --title <title> --body <body>`
7. **关闭/重新打开**: `gh issue close [<number>]` / `gh issue reopen [<number>]`
8. **转移 Issue**: `gh issue transfer [<number>] <owner/repo>`

## 输出格式化

- **列表输出**: 转换为 Markdown 表格格式（使用 output-formatter.ps1）
- **JSON 输出**: 使用 PowerShell 转换为易读格式
- **错误信息**: 清晰标注错误原因和解决建议
- **成功状态**: 显示操作结果和后续建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `PowerShell` - Windows 脚本环境
- `git` - Git 版本控制