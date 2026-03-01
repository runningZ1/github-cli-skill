---
name: github-secret
description: 通过自然语言执行 GitHub Secrets 管理（列表、设置、删除）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Secrets 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 完整控制私有仓库
- `admin:org` - 组织级别 secrets（仅组织 secrets）

## 支持的操作

### 1. 列出 Secrets

```
/github-secret list [--org <org>] [--env <environment>]
```

**示例：**
- `/github-secret list` - 列出仓库 secrets
- `/github-secret list --org myorg` - 列出组织 secrets
- `/github-secret list --env production` - 列出环境 secrets

### 2. 设置 Secret

```
/github-secret set <secret-name> --body <value> [--org <org>] [--env <environment>] [--visibility <all|private|selected>|--repositories <repo-list>]
```

**示例：**
- `/github-secret set API_KEY --body "sk-xxx"` - 设置仓库 secret
- `/github-secret set DEPLOY_KEY --body "key123" --env production` - 设置环境 secret
- `/github-secret set ORG_SECRET --body "value" --org myorg` - 设置组织 secret
- `/github-secret set ORG_SECRET --body "value" --org myorg --visibility selected --repositories repo1,repo2` - 设置组织 secret 并指定仓库

### 3. 删除 Secret

```
/github-secret delete <secret-name> [--org <org>] [--env <environment>]
```

**示例：**
- `/github-secret delete API_KEY` - 删除仓库 secret
- `/github-secret delete DEPLOY_KEY --env production` - 删除环境 secret
- `/github-secret delete ORG_SECRET --org myorg` - 删除组织 secret

### 4. 查看 Secret 详情

```
/github-secret view <secret-name> [--org <org>] [--env <environment>]
```

**示例：**
- `/github-secret view API_KEY` - 查看 secret 详情
- `/github-secret view DEPLOY_KEY --env production` - 查看环境 secret

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出 secrets**: `gh secret list --json <fields>`
2. **设置 secret**: `gh secret set <name> --body <value> --env <env> --org <org>`
3. **删除 secret**: `gh secret delete <name> --env <env> --org <org>`
4. **查看 secret**: `gh secret list --json <fields> | jq '.[] | select(.name=="<name>")'`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、最后更新时间、可见性
- **详情输出**: 显示名称、最后更新时间、作用域
- **安全提示**: 不显示 secret 实际值
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 设置 CI/CD 凭证
```
# 设置 Docker Hub 凭证
/github-secret set DOCKER_USERNAME --body "myusername"
/github-secret set DOCKER_PASSWORD --body "mypassword"

# 设置云服务凭证
/github-secret set AWS_ACCESS_KEY_ID --body "AKIAXXXXXXXXXXXXXXXX"
/github-secret set AWS_SECRET_ACCESS_KEY --body "secret-key"
/github-secret set AWS_REGION --body "us-east-1"

# 设置部署密钥
/github-secret set DEPLOY_KEY --body "ssh-rsa AAAA..." --env production
```

### 场景 2: 设置 API 密钥
```
# 设置第三方 API 密钥
/github-secret set OPENAI_API_KEY --body "sk-..."
/github-secret set GITHUB_TOKEN --body "ghp_..."
/github-secret set SLACK_WEBHOOK --body "https://hooks.slack.com/..."
```

### 场景 3: 组织级别 Secrets
```
# 设置组织级别的 secret（所有仓库可用）
/github-secret set ORG_DEPLOY_KEY --body "key" --org myorg

# 设置组织 secret 仅特定仓库可用
/github-secret set ORG_SECRET --body "value" \
  --org myorg \
  --visibility selected \
  --repositories repo1,repo2,repo3
```

### 场景 4: 环境 Secrets
```
# 设置不同环境的 secrets
/github-secret set DATABASE_URL --body "postgres://dev-db..." --env development
/github-secret set DATABASE_URL --body "postgres://staging-db..." --env staging
/github-secret set DATABASE_URL --body "postgres://prod-db..." --env production

# 设置 API 密钥（不同环境不同值）
/github-secret set API_KEY --body "dev-key" --env development
/github-secret set API_KEY --body "prod-key" --env production
```

### 场景 5: 管理 Secrets
```
# 查看所有 secrets
/github-secret list

# 查看特定 secret
/github-secret view API_KEY

# 删除过期的 secret
/github-secret delete OLD_API_KEY

# 更新 secret（先删除再设置）
/github-secret delete API_KEY
/github-secret set API_KEY --body "new-key"
```

### 场景 6: 批量设置 Secrets
```
# 一次性设置多个相关 secrets
/github-secret set NPM_TOKEN --body "npm_xxx"
/github-secret set NPM_USERNAME --body "username"
/github-secret set NPM_EMAIL --body "email@example.com"
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **安全性**:
   - Secret 值在设置后无法查看
   - 日志中不会显示 secret 值
   - 使用强密码/密钥

2. **可见性级别**（组织 secrets）:
   - `all`: 组织内所有仓库
   - `private`: 仅私有仓库
   - `selected`: 指定仓库

3. **命名规则**:
   - 只能包含大写字母、数字、下划线
   - 不能以 `GITHUB_` 或 `ACTIONS_` 开头
   - 不能以 `CI_` 开头（ reserved for GitHub Actions）

4. **数量限制**:
   - 每个仓库最多 100 个 secrets
   - 每个组织最多 1000 个 secrets

5. **加密**:
   - GitHub 使用 libsodium 加密
   - 传输过程中使用 GitHub 公钥加密

## 最佳实践

### 1. 命名规范
```
# 使用描述性名称
DEPLOY_KEY        # 好
API_KEY           # 好
PROD_DB_PASSWORD  # 好

# 避免模糊命名
KEY               # 不好
SECRET            # 不好
```

### 2. 环境隔离
```
# 不同环境使用不同的 secret
DEV_DATABASE_URL
STAGING_DATABASE_URL
PROD_DATABASE_URL
```

### 3. 定期轮换
```
# 定期更新敏感 credentials
/github-secret delete API_KEY
/github-secret set API_KEY --body "new-rotated-key"
```

### 4. 最小权限
```
# 使用最小权限的 token
/github-secret set CI_TOKEN --body "ghp_ limited-scope-token"
```

## 与 GitHub Actions 集成

设置 secrets 后，在 workflow 中使用：

```yaml
# .github/workflows/deploy.yml
name: Deploy
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./deploy.sh
        env:
          API_KEY: ${{ secrets.API_KEY }}
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
```
