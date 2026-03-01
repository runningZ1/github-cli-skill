---
name: github-search
description: 通过自然语言搜索 GitHub 资源（仓库、Issue、PR、代码、用户）
version: 1.0.0
argument-hint: <type> <query> [options]
allowed-tools: Bash(*)
---

# GitHub 搜索技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- 无需特殊权限（公开搜索）
- `repo` - 搜索私有仓库

## 支持的操作

### 1. 搜索仓库

```
/github-search repos <query> [--limit <n>] [--sort stars|forks|help-wanted-issues|updated] [--order asc|desc]
```

**示例：**
- `/github-search repos python web scraper` - 搜索 Python 网页爬虫
- `/github-search repos react ui --sort stars --limit 10` - 搜索热门 React UI
- `/github-search repos machine-learning --sort updated` - 搜索最新 ML 项目

### 2. 搜索 Issues

```
/github-search issues <query> [--state open|closed] [--sort created|updated|comments] [--limit <n>]
```

**示例：**
- `/github-search issues "bug" --state open` - 搜索开放的 bug
- `/github-search issues "help wanted" --sort updated` - 搜索最新帮助请求

### 3. 搜索 PRs

```
/github-search prs <query> [--state open|closed|merged] [--sort created|updated] [--limit <n>]
```

**示例：**
- `/github-search prs "fix" --state open` - 搜索开放的修复 PR
- `/github-search prs "feature" --state merged` - 搜索已合并的功能 PR

### 4. 搜索代码

```
/github-search code <query> [--limit <n>]
```

**示例：**
- `/github-search code "def main" language:python` - 搜索 Python main 函数
- `/github-search code "TODO" language:javascript` - 搜索 JS TODO 注释

### 5. 搜索 Commits

```
/github-search commits <query> [--limit <n>]
```

**示例：**
- `/github-search commits "fix bug" --limit 10` - 搜索修复 bug 的提交

### 6. 搜索用户

```
/github-search users <query> [--limit <n>]
```

**示例：**
- `/github-search users "python developer" --limit 10` - 搜索 Python 开发者

## 搜索语法

### 仓库搜索限定词

| 限定词 | 描述 | 示例 |
|--------|------|------|
| `in:name` | 名称中包含 | `react in:name` |
| `in:description` | 描述中包含 | `web framework in:description` |
| `language:<lang>` | 编程语言 | `language:python` |
| `topics:<topic>` | 包含主题 | `topics:machine-learning` |
| `stars:>N` | 星星数大于 | `stars:>1000` |
| `forks:>N` | Fork 数大于 | `forks:>100` |
| `license:<license>` | 许可证 | `license:mit` |
| `pushed:>YYYY-MM-DD` | 最近推送 | `pushed:>2024-01-01` |
| `created:>YYYY-MM-DD` | 创建时间 | `created:>2024-01-01` |
| `user:<username>` | 特定用户 | `user:octocat` |
| `org:<orgname>` | 特定组织 | `org:microsoft` |

### Issue/PR 搜索限定词

| 限定词 | 描述 | 示例 |
|--------|------|------|
| `is:issue` | 仅 issue | `is:issue bug` |
| `is:pr` | 仅 PR | `is:pr fix` |
| `is:open` | 开放的 | `is:open bug` |
| `is:closed` | 已关闭 | `is:closed fixed` |
| `is:merged` | 已合并 (PR) | `is:merged feature` |
| `label:<label>` | 标签 | `label:bug` |
| `author:<user>` | 作者 | `author:octocat` |
| `assignee:<user>` | 分配给 | `assignee:octocat` |
| `mentions:<user>` | 提及 | `mentions:octocat` |
| `commenter:<user>` | 评论者 | `commenter:octocat` |
| `involves:<user>` | 涉及 | `involves:octocat` |
| `reviewed-by:<user>` | 审核者 | `reviewed-by:octocat` |

### 代码搜索限定词

| 限定词 | 描述 | 示例 |
|--------|------|------|
| `language:<lang>` | 编程语言 | `language:python` |
| `path:<path>` | 文件路径 | `path:src/` |
| `extension:<ext>` | 文件扩展名 | `extension:py` |
| `filename:<name>` | 文件名 | `filename:package.json` |
| `repo:<owner/repo>` | 仓库 | `repo:cli/cli` |

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **搜索仓库**: `gh search repos <query> --json <fields> --limit <n>`
2. **搜索 Issues**: `gh search issues <query> --json <fields> --limit <n>`
3. **搜索 PRs**: `gh search prs <query> --json <fields> --limit <n>`
4. **搜索代码**: `gh search code <query> --json <fields> --limit <n>`
5. **搜索 Commits**: `gh search commits <query> --json <fields> --limit <n>`
6. **搜索用户**: `gh search users <query> --json <fields> --limit <n>`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、描述、统计信息
- **详细信息**: 显示完整信息包括链接
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load
```

## 使用场景

### 场景 1: 发现优秀项目
```
# 搜索热门 Python 项目
/github-search repos python --sort stars --limit 10

# 搜索最近流行的项目
/github-search repos --sort updated --pushed:>2024-01-01
```

### 场景 2: 寻找 Issue
```
# 搜索 help wanted 标签的 issue
/github-search issues "help wanted" label:"help wanted"

# 搜索特定仓库的 issue
/github-search issues repo:cli/cli is:open
```

### 场景 3: 代码搜索
```
# 搜索特定函数实现
/github-search code "function debounce" language:javascript

# 搜索配置文件
/github-search code "eslint.config" filename:eslint.config.js
```

### 场景 4: 寻找合作伙伴
```
# 搜索活跃开发者
/github-search users "python developer" location:"San Francisco"
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **搜索限制**: 未登录用户有速率限制
2. **私有内容**: 搜索私有仓库需要 `repo` 权限
3. **搜索结果**: 最多返回 1000 条结果
4. **复杂查询**: 使用引号包裹短语
