---
name: github-api
description: 通过自然语言执行 GitHub API 调用（REST 和 GraphQL）
version: 1.0.0
argument-hint: <endpoint> [options]
allowed-tools: Bash(*)
---

# GitHub API 调用技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- 根据 API 端点而定

## 支持的操作

### 1. GET 请求

```
/github-api get <endpoint>
```

**示例：**
- `/github-api get /repos/{owner}/{repo}` - 获取仓库信息
- `/github-api get /user` - 获取当前用户信息
- `/github-api get /repos/{owner}/{repo}/issues` - 获取 issue 列表

### 2. POST 请求

```
/github-api post <endpoint> [--field key=value...]
```

**示例：**
- `/github-api post /repos/{owner}/{repo}/issues -f title="Bug" -f body="Description"`
- `/github-api post /user/repos -f name="new-repo" -f private=true`

### 3. PUT 请求

```
/github-api put <endpoint> [--field key=value...]
```

**示例：**
- `/github-api put /repos/{owner}/{repo} -f description="Updated"`

### 4. PATCH 请求

```
/github-api patch <endpoint> [--field key=value...]
```

**示例：**
- `/github-api patch /user -f name="New Name"`

### 5. DELETE 请求

```
/github-api delete <endpoint>
```

**示例：**
- `/github-api delete /repos/{owner}/{repo}` - 删除仓库

### 6. GraphQL 查询

```
/github-api graphql --query <query> [--field key=value...]
```

**示例：**
- `/github-api graphql --query "query { viewer { login name } }"`

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **GET**: `gh api <endpoint> --method GET --json <fields>`
2. **POST**: `gh api <endpoint> --method POST -f <field>=<value>`
3. **PUT**: `gh api <endpoint> --method PUT -f <field>=<value>`
4. **PATCH**: `gh api <endpoint> --method PATCH -f <field>=<value>`
5. **DELETE**: `gh api <endpoint> --method DELETE`
6. **GraphQL**: `gh api graphql -f query='<query>'`

## 输出格式化

- **JSON 输出**: 格式化 JSON
- **表格输出**: 转换为 Markdown 表格
- **错误信息**: 清晰标注 HTTP 状态码和错误信息

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 获取仓库信息
```
# 获取当前仓库信息
/github-api get /repos/{owner}/{repo}

# 获取仓库列表
/github-api get /user/repos
```

### 场景 2: 创建资源
```
# 创建 issue
/github-api post /repos/{owner}/{repo}/issues \
  --field title="Bug Report" \
  --field body="Description" \
  --field labels='["bug"]'

# 创建 PR
/github-api post /repos/{owner}/{repo}/pulls \
  --field title="Fix" \
  --field head="feature" \
  --field base="main"
```

### 场景 3: 更新资源
```
# 更新仓库
/github-api patch /repos/{owner}/{repo} \
  --field description="New description"
```

### 场景 4: GraphQL 查询
```
# 查询用户信息
/github-api graphql --query "query { viewer { login name email } }"

# 查询仓库信息
/github-api graphql \
  --field owner="{owner}" \
  --field name="{repo}" \
  --query "query($name: String!, $owner: String!) { repository(owner: $owner, name: $name) { stargazerCount } }"
```

## 常用 API 端点

### 用户
- `GET /user` - 当前用户
- `GET /users/{username}` - 指定用户
- `PATCH /user` - 更新用户

### 仓库
- `GET /repos/{owner}/{repo}` - 仓库信息
- `POST /user/repos` - 创建仓库
- `PATCH /repos/{owner}/{repo}` - 更新仓库
- `DELETE /repos/{owner}/{repo}` - 删除仓库

### Issues
- `GET /repos/{owner}/{repo}/issues` - Issue 列表
- `POST /repos/{owner}/{repo}/issues` - 创建 Issue
- `PATCH /repos/{owner}/{repo}/issues/{number}` - 更新 Issue

### Pull Requests
- `GET /repos/{owner}/{repo}/pulls` - PR 列表
- `POST /repos/{owner}/{repo}/pulls` - 创建 PR
- `PATCH /repos/{owner}/{repo}/pulls/{number}` - 更新 PR

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **占位符**: `{owner}`, `{repo}` 会自动替换
2. **速率限制**: API 有速率限制
3. **权限**: 需要适当的 OAuth scopes
4. **分页**: 使用 `--paginate` 获取所有结果
