---
name: github-pr
description: 通过自然语言执行 GitHub Pull Request 相关操作（创建、查看、列表、合并、评论等）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Pull Request 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

## 支持的操作

### 1. 创建 Pull Request

```
/github-pr create [--title "title"] [--body "description"] [--base branch] [--head branch]
```

**示例：**
- `/github-pr create --title "Fix login bug" --body "Resolves #123"`
- `/github-pr create --title "Add new feature" --base main --head feature/new-feature`
- `/github-pr create` - 使用交互式方式创建

### 2. 查看 Pull Request

```
/github-pr view [pr-number] [--web]
```

**示例：**
- `/github-pr view` - 查看当前分支关联的 PR
- `/github-pr view 123` - 查看 PR #123
- `/github-pr view 123 --web` - 在浏览器中打开 PR

### 3. Pull Request 列表

```
/github-pr list [--state open|closed|merged] [--author user] [--limit n]
```

**示例：**
- `/github-pr list` - 查看所有开放的 PR
- `/github-pr list --state open --limit 10` - 查看 10 个开放的 PR
- `/github-pr list --author octocat` - 查看 octocat 创建的 PR

### 4. 合并 Pull Request

```
/github-pr merge [pr-number] [--merge|--rebase|--squash] [--delete-branch]
```

**示例：**
- `/github-pr merge 123` - 合并 PR #123
- `/github-pr merge 123 --squash --delete-branch` - 压缩合并并删除分支
- `/github-pr merge --merge` - 合并当前分支的 PR

### 5. 评论 Pull Request

```
/github-pr comment [pr-number] --body "comment"
```

**示例：**
- `/github-pr comment 123 --body "LGTM! Ready to merge"`
- `/github-pr comment --body "Please address the review comments"`

### 6. 更新 Pull Request

```
/github-pr edit [pr-number] [--title "title"] [--body "description"] [--base branch]
```

**示例：**
- `/github-pr edit 123 --title "Updated title"`
- `/github-pr edit 123 --body "Updated description with more details"`
- `/github-pr edit 123 --base main`

### 7. 检查 PR 状态

```
/github-pr checks [pr-number] [--watch]
```

**示例：**
- `/github-pr checks 123` - 查看 PR #123 的检查状态
- `/github-pr checks --watch` - 实时监控检查状态

### 8. 关联 Issue

```
/github-pr edit [pr-number] --add-assignee user --add-label label
```

**示例：**
- `/github-pr edit 123 --add-assignee octocat`
- `/github-pr edit 123 --add-label bug --add-label priority-high`

### 9. 关闭/重新打开 Issue

```
/github-pr close [pr-number]
/github-pr reopen [pr-number]
```

**示例：**
- `/github-pr close 123` - 关闭 PR #123
- `/github-pr reopen 123` - 重新打开 PR #123

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **创建 PR**: `gh pr create --title <title> --body <body> --base <base> --head <head>`
2. **查看 PR**: `gh pr view [<number>] --json <fields>`
3. **PR 列表**: `gh pr list --state <state> --author <user> --limit <n> --json <fields>`
4. **合并 PR**: `gh pr merge [<number>] --merge|--rebase|--squash --delete-branch`
5. **评论 PR**: `gh pr comment [<number>] --body <comment>`
6. **编辑 PR**: `gh pr edit [<number>] --title <title> --body <body> --base <base>`
7. **检查状态**: `gh pr checks [<number>]`
8. **关闭/重新打开**: `gh pr close [<number>]` / `gh pr reopen [<number>]`

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