---
name: github-ruleset
description: 通过自然语言查看 GitHub 仓库规则集（列表、查看、检查）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub Ruleset 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 访问私有仓库

## 支持的操作

### 1. 列出规则集

```
/github-ruleset list [--repo <owner/repo>] [--org <org>]
```

**示例：**
- `/github-ruleset list` - 列出当前仓库的规则集
- `/github-ruleset list --repo cli/cli` - 列出指定仓库的规则集
- `/github-ruleset list --org microsoft` - 列出组织的规则集

### 2. 查看规则集详情

```
/github-ruleset view <ruleset-id> [--repo <owner/repo>]
```

**示例：**
- `/github-ruleset view 123` - 查看指定规则集
- `/github-ruleset view 123 --repo cli/cli` - 查看指定仓库的规则集

### 3. 检查规则适用性

```
/github-ruleset check <branch> [--repo <owner/repo>]
```

**示例：**
- `/github-ruleset check main` - 检查 main 分支适用的规则
- `/github-ruleset check develop --repo cli/cli` - 检查 develop 分支

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出规则集**: `gh ruleset list --json <fields>`
2. **查看规则集**: `gh ruleset view <id> --json <fields>`
3. **检查规则**: `gh ruleset check <branch>`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、名称、目标、状态
- **详情输出**: 显示完整规则配置
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 查看仓库规则
```
# 列出所有规则集
/github-ruleset list

# 查看特定规则集详情
/github-ruleset view 123
```

### 场景 2: 检查分支规则
```
# 检查 main 分支的规则
/github-ruleset check main
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **规则集类型**: 支持仓库规则集和组织规则集
2. **权限**: 需要读取仓库权限
3. **规则内容**: 包括分支保护、PR 要求等
