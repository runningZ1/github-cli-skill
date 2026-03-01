---
name: github-workflow
description: 通过自然语言执行 GitHub Actions 工作流管理（查看、启用、禁用、运行）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Actions 工作流管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 访问私有仓库
- `workflow` - 管理工作流

## 支持的操作

### 1. 列出工作流

```
/github-workflow list [--limit <n>]
```

**示例：**
- `/github-workflow list` - 列出所有工作流
- `/github-workflow list --limit 10` - 列出前 10 个工作流

### 2. 查看工作流详情

```
/github-workflow view <workflow-id|workflow-name|workflow-file>
```

**示例：**
- `/github-workflow view ci.yml` - 查看 CI 工作流
- `/github-workflow view deploy` - 查看部署工作流
- `/github-workflow view 12345` - 通过 ID 查看

### 3. 启用工作流

```
/github-workflow enable <workflow-id|workflow-name|workflow-file>
```

**示例：**
- `/github-workflow enable ci.yml` - 启用 CI 工作流
- `/github-workflow enable deploy` - 启用部署工作流

### 4. 禁用工作流

```
/github-workflow disable <workflow-id|workflow-name|workflow-file>
```

**示例：**
- `/github-workflow disable ci.yml` - 禁用 CI 工作流
- `/github-workflow disable stale` - 禁用 stale 机器人工作流

### 5. 运行工作流

```
/github-workflow run <workflow-id|workflow-name|workflow-file> [--ref <branch>] [--field key=value...]
```

**示例：**
- `/github-workflow run deploy.yml --ref main` - 在 main 分支运行部署
- `/github-workflow run ci.yml --field environment=staging` - 带参数运行
- `/github-workflow run "Release Drafter" --ref main` - 运行指定名称的工作流

### 6. 查看工作流运行历史

```
/github-workflow history <workflow-id|workflow-name> [--limit <n>] [--status success|failure|skipped]
```

**示例：**
- `/github-workflow history ci.yml` - 查看 CI 运行历史
- `/github-workflow history deploy --status failure --limit 5` - 查看失败的部署

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出工作流**: `gh workflow list --json <fields> --limit <n>`
2. **查看工作流**: `gh workflow view <workflow> --yaml`
3. **启用工作流**: `gh workflow enable <workflow>`
4. **禁用工作流**: `gh workflow disable <workflow>`
5. **运行工作流**: `gh workflow run <workflow> --ref <branch> -f <field>=<value>`
6. **运行历史**: `gh run list --workflow <workflow> --json <fields> --limit <n>`

## 输出格式化

- **列表输出**: 转换为 Markdown 表格，显示名称、状态、上次运行时间
- **YAML 输出**: 语法高亮显示工作流配置
- **运行历史**: 显示运行 ID、状态、分支、触发时间
- **错误信息**: 清晰标注错误原因和解决建议
- **成功状态**: 显示操作结果和运行链接

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: CI/CD 工作流管理
```
# 查看当前有哪些工作流
/github-workflow list

# 查看 CI 配置
/github-workflow view ci.yml

# 在特定分支运行 CI
/github-workflow run ci.yml --ref feature/new-feature
```

### 场景 2: 禁用/启用工作流
```
# 临时禁用 stale 机器人
/github-workflow disable stale.yml

# 重新启用
/github-workflow enable stale.yml
```

### 场景 3: 部署工作流
```
# 运行部署到生产环境
/github-workflow run deploy.yml --ref main --field environment=production

# 查看部署历史
/github-workflow history deploy.yml --limit 10
```

### 场景 4: 故障排查
```
# 查看失败的工作流运行
/github-workflow history ci.yml --status failure --limit 5

# 查看工作流详细配置
/github-workflow view ci.yml
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具
- `git` - Git 版本控制

## 注意事项

1. **workflow 权限**: 需要 `workflow` scope 才能运行工作流
2. **workflow_dispatch**: 只有包含 `workflow_dispatch` 触发器的工作流才能手动运行
3. **分支保护**: 某些工作流可能只能在特定分支运行
4. **运行限制**: 私有仓库有 Actions 分钟数限制
