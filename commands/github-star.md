---
name: github-star
description: 查看和管理 GitHub Star 项目（支持分类文件夹）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Star 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 访问私有仓库的 Star
- `read:org` - 读取组织信息

## 支持的操作

### 1. 查看 Star 列表

```
/github-star list [--limit <n>] [--sort created|updated] [--order asc|desc]
```

**示例：**
- `/github-star list` - 查看最近的 Star
- `/github-star list --limit 20` - 查看最近 20 个 Star
- `/github-star list --sort created --order desc` - 按创建时间倒序

### 2. 查看 Star 分类列表

```
/github-star lists
```

**示例：**
- `/github-star lists` - 查看所有 Star 分类文件夹

### 3. 查看分类内容

```
/github-star list <list-name>
```

**示例：**
- `/github-star list "机器学习"` - 查看机器学习分类的项目
- `/github-star list "前端框架"` - 查看前端框架分类的项目

### 4. 搜索 Star

```
/github-star search <query> [--limit <n>]
```

**示例：**
- `/github-star search python` - 搜索已 Star 的 Python 项目
- `/github-star search "machine learning" --limit 10` - 搜索 ML 项目

### 5. Star 项目

```
/github-star add <owner/repo>
```

**示例：**
- `/github-star add octocat/Hello-World` - Star 一个项目

### 6. 取消 Star

```
/github-star remove <owner/repo>
```

**示例：**
- `/github-star remove octocat/Hello-World` - 取消 Star 一个项目

### 7. 检查是否已 Star

```
/github-star check <owner/repo>
```

**示例：**
- `/github-star check cli/cli` - 检查是否已 Star 该项目

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **查看 Star 列表**: `gh api --paginate /user/starred --sort created --direction desc`
2. **查看分类列表**: `gh api /user/starred/lists`
3. **查看分类内容**: `gh api /user/starred/lists/{list_id}`
4. **搜索 Star**: 本地过滤已获取的 Star 列表
5. **Star 项目**: `gh api -X PUT /user/starred/{owner}/{repo}`
6. **取消 Star**: `gh api -X DELETE /user/starred/{owner}/{repo}`
7. **检查是否已 Star**: `gh api /user/starred/{owner}/{repo}`

## 输出格式化

- **Star 列表**: Markdown 表格，显示名称、描述、语言、Star 时间
- **分类列表**: Markdown 列表，显示分类名称和项目数量
- **分类内容**: Markdown 表格，显示名称、描述、添加时间
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 回顾最近 Star 的项目

```
# 查看最近 10 个 Star
/github-star list --limit 10
```

### 场景 2: 管理 Star 分类

```
# 查看所有分类
/github-star lists

# 查看特定分类
/github-star list "机器学习"
```

### 场景 3: 搜索已 Star 的项目

```
# 搜索 Python 相关项目
/github-star search python

# 搜索特定主题
/github-star search "deep learning" --limit 15
```

### 场景 4: Star 管理

```
# Star 一个新项目
/github-star add microsoft/TypeScript

# 取消 Star
/github-star remove user/repo

# 检查是否已 Star
/github-star check facebook/react
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **认证**: 需要有效的 GitHub Token
2. **私有仓库**: Star 私有仓库需要 `repo` 权限
3. **分类功能**: Star 分类是 GitHub 较新的功能，确保 gh CLI 版本够新
4. **速率限制**: API 调用有速率限制，大量操作时注意

## API 端点参考

| 操作 | 端点 | 方法 |
|------|------|------|
| 获取 Star 列表 | `/user/starred` | GET |
| 获取分类列表 | `/user/starred/lists` | GET |
| 获取分类内容 | `/user/starred/lists/{list_id}` | GET |
| Star 项目 | `/user/starred/{owner}/{repo}` | PUT |
| 取消 Star | `/user/starred/{owner}/{repo}` | DELETE |
| 检查是否已 Star | `/user/starred/{owner}/{repo}` | GET |
