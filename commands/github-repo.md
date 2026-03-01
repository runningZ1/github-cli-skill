---
name: github-repo
description: 通过自然语言执行 GitHub 仓库相关操作（创建、克隆、查看、同步等）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub 仓库管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `source ~/.claude/skills/github-cli/lib/auth-manager.sh` 加载环境变量

## 支持的操作

### 1. 创建仓库

```
/github-repo create <repo-name> [--public|--private] [--description "xxx"]
```

**示例：**
- `/github-repo create my-project --private --description "My awesome project"`
- `/github-repo create open-source-project --public`

### 2. 克隆仓库

```
/github-repo clone <owner/repo> [--directory <dir>]
```

**示例：**
- `/github-repo clone octocat/Hello-World`
- `/github-repo clone octocat/Hello-World --directory my-project`

### 3. 查看仓库信息

```
/github-repo view [owner/repo] [--web]
```

**示例：**
- `/github-repo view` - 查看当前仓库
- `/github-repo view octocat/Hello-World`
- `/github-repo view --web` - 在浏览器中打开

### 4. Fork 仓库

```
/github-repo fork <owner/repo> [--clone]
```

**示例：**
- `/github-repo fork octocat/Hello-World --clone`

### 5. 同步仓库

```
/github-repo sync [owner/repo]
```

**示例：**
- `/github-repo sync` - 同步当前 fork 的仓库
- `/github-repo sync octocat/Hello-World`

### 6. 仓库提交更新工作流

```
/github-repo commit "<message>" [--push] [--branch <branch-name>]
```

**示例：**
- `/github-repo commit "Fix bug in login flow"`
- `/github-repo commit "Add new feature" --push --branch feature/new-feature`

### 7. 仓库列表

```
/github-repo list [--visibility all|public|private] [--limit <n>]
```

**示例：**
- `/github-repo list --visibility private --limit 10`

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **创建仓库**: `gh repo create <name> --visibility <public|private> --description <desc>`
2. **克隆仓库**: `gh repo clone <owner/repo> [<directory>]`
3. **查看仓库**: `gh repo view [<owner/repo>] --json <fields>`
4. **Fork 仓库**: `gh repo fork <owner/repo> --clone`
5. **同步仓库**: `gh repo sync [<owner/repo>]`
6. **提交更新**: 使用 git 命令 + gh 组合
7. **仓库列表**: `gh repo list --visibility <type> --limit <n> --json <fields>`

## 输出格式化

- **列表输出**: 转换为 Markdown 表格格式
- **JSON 输出**: 使用 jq 格式化后转为易读格式
- **错误信息**: 清晰标注错误原因和解决建议
- **成功状态**: 显示操作结果和后续建议

## 环境变量设置

```bash
# 加载认证信息
export GH_TOKEN=$(grep "^GH_TOKEN=" ~/.claude/skills/github-cli/.env | cut -d'=' -f2-)

# 验证认证
gh auth status
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具
- `git` - Git 版本控制
