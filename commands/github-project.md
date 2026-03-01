---
name: github-project
description: 通过自然语言管理 GitHub Projects（查看、创建、编辑、管理 items）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Projects 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 完整控制私有仓库
- `project` - 管理 Projects

## 支持的操作

### 1. 列出 Projects

```
/github-project list --owner <owner> [--limit <n>]
```

**示例：**
- `/github-project list --owner octocat` - 列出用户项目
- `/github-project list --owner microsoft` - 列出组织项目

### 2. 查看 Project

```
/github-project view <project-number> --owner <owner>
```

**示例：**
- `/github-project view 1 --owner cli` - 查看项目 #1
- `/github-project view 1 --owner cli --web` - 在浏览器中打开

### 3. 创建 Project

```
/github-project create --owner <owner> --title <title>
```

**示例：**
- `/github-project create --owner cli --title "Roadmap 2024"`

### 4. 编辑 Project

```
/github-project edit <project-number> --owner <owner> [--title <title>]
```

**示例：**
- `/github-project edit 1 --owner cli --title "Updated Title"`

### 5. 关闭 Project

```
/github-project close <project-number> --owner <owner>
```

**示例：**
- `/github-project close 1 --owner cli`

### 6. 删除 Project

```
/github-project delete <project-number> --owner <owner>
```

**示例：**
- `/github-project delete 1 --owner cli`

### 7. 复制 Project

```
/github-project copy <project-number> --owner <owner> --target-owner <target-owner> --title <title>
```

**示例：**
- `/github-project copy 1 --owner cli --target-owner cli --title "Roadmap Copy"`

### 8. 管理 Fields

```
/github-project field-list <project-number> --owner <owner>
/github-project field-create <project-number> --owner <owner> --name <name> --data-type <type>
/github-project field-delete <field-id>
```

**示例：**
- `/github-project field-list 1 --owner cli`
- `/github-project field-create 1 --owner cli --name "Status" --data-type single_select`

### 9. 管理 Items

```
/github-project item-list <project-number> --owner <owner>
/github-project item-create <project-number> --owner <owner> --title <title>
/github-project item-add <project-number> --owner <owner> --url <issue/pr-url>
/github-project item-edit <item-id> --field-id <field-id> --value <value>
/github-project item-archive <item-id>
/github-project item-delete <item-id>
```

**示例：**
- `/github-project item-list 1 --owner cli`
- `/github-project item-create 1 --owner cli --title "New Feature"`
- `/github-project item-add 1 --owner cli --url "https://github.com/cli/cli/issues/123"`

### 10. 链接 Project

```
/github-project link <project-number> --owner <owner> --repo <repo>
/github-project unlink <project-number> --owner <owner> --repo <repo>
```

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出项目**: `gh project list --owner <owner> --json <fields>`
2. **查看项目**: `gh project view <number> --owner <owner>`
3. **创建项目**: `gh project create --owner <owner> --title <title>`
4. **编辑项目**: `gh project edit <number> --owner <owner>`
5. **管理 items**: `gh project item-*`

## 输出格式化

- **列表输出**: Markdown 表格，显示项目名称、状态、items 数量
- **详情输出**: 显示项目信息、fields、items
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 创建路线图
```
# 创建项目
/github-project create --owner cli --title "2024 Roadmap"

# 添加字段
/github-project field-create 1 --owner cli --name "Priority" --data-type single_select

# 添加 items
/github-project item-create 1 --owner cli --title "Feature A"
```

### 场景 2: 管理 Issue/PR
```
# 添加 issue 到项目
/github-project item-add 1 --owner cli --url "https://github.com/cli/cli/issues/123"

# 编辑 item 状态
/github-project item-edit <item-id> --field-id <status-field-id> --value "In Progress"
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **Project 类型**: 支持 Projects (Classic) 和 Projects v2
2. **权限**: 需要 `project` scope
3. **所有者**: 可以是用户或组织
