---
name: github-alias
description: 通过自然语言管理 GitHub CLI 别名（创建、查看、删除、导入）
version: 1.0.0
argument-hint: [operation] [name] [expansion]
allowed-tools: Bash(*)
---

# GitHub CLI 别名管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

## 支持的操作

### 1. 列出别名

```
/github-alias list
```

**示例：**
- `/github-alias list` - 列出所有已定义的别名

### 2. 创建别名

```
/github-alias set <name> <expansion>
```

**示例：**
- `/github-alias set co pr checkout` - 创建快捷别名
- `/github-alias set mypr "pr list --author @me"` - 带参数的别名

### 3. 删除别名

```
/github-alias delete <name>
```

**示例：**
- `/github-alias delete co` - 删除别名

### 4. 导入别名

```
/github-alias import <file>
```

**示例：**
- `/github-alias import aliases.yml` - 从文件导入别名

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出别名**: `gh alias list`
2. **创建别名**: `gh alias set <name> <expansion>`
3. **删除别名**: `gh alias delete <name>`
4. **导入别名**: `gh alias import <file>`

## 输出格式化

- **列表输出**: 显示别名和对应的命令
- **成功状态**: 显示操作结果
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load
```

## 使用场景

### 场景 1: 创建常用快捷方式
```
# 创建 PR checkout 快捷方式
/github-alias set co pr checkout

# 创建查看我的 PR 快捷方式
/github-alias set mypr "pr list --author @me"

# 创建创建 PR 快捷方式
/github-alias set newpr "pr create --assignee @me"
```

### 场景 2: 查看别名
```
# 列出所有别名
/github-alias list
```

### 场景 3: 管理别名
```
# 删除不需要的别名
/github-alias delete co

# 导入别名配置
/github-alias import aliases.yml
```

## 别名配置示例

```yaml
# aliases.yml
co: pr checkout
mypr: pr list --author @me
newpr: pr create --assignee @me
ils: issue list --state open
ic: issue create
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **参数引用**: 带空格的 expansion 需要用引号包裹
2. **参数占位**: 使用 `$1`, `$2` 等作为参数占位符
3. **冲突**: 别名不能与现有 gh 命令同名
