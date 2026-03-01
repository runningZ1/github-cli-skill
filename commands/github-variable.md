---
name: github-variable
description: 通过自然语言执行 GitHub Variables 管理（列表、获取、设置、删除）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Variables 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 完整控制私有仓库
- `admin:org` - 组织级别 variables（仅组织 variables）

## 支持的操作

### 1. 列出 Variables

```
/github-variable list [--org <org>] [--env <environment>]
```

**示例：**
- `/github-variable list` - 列出仓库 variables
- `/github-variable list --org myorg` - 列出组织 variables
- `/github-variable list --env production` - 列出环境 variables

### 2. 获取 Variable

```
/github-variable get <variable-name> [--org <org>] [--env <environment>]
```

**示例：**
- `/github-variable get APP_NAME` - 获取 variable 值
- `/github-variable get DATABASE_URL --env production` - 获取环境 variable

### 3. 设置 Variable

```
/github-variable set <variable-name> --body <value> [--org <org>] [--env <environment>] [--visibility <all|private|selected>] [--repositories <repo-list>]
```

**示例：**
- `/github-variable set APP_NAME --body "MyApp"` - 设置仓库 variable
- `/github-variable set NODE_ENV --body "production" --env production` - 设置环境 variable
- `/github-variable set ORG_VAR --body "value" --org myorg` - 设置组织 variable
- `/github-variable set ORG_VAR --body "value" --org myorg --visibility selected --repositories repo1,repo2` - 设置组织 variable 并指定仓库

### 4. 删除 Variable

```
/github-variable delete <variable-name> [--org <org>] [--env <environment>]
```

**示例：**
- `/github-variable delete APP_NAME` - 删除仓库 variable
- `/github-variable delete NODE_ENV --env production` - 删除环境 variable
- `/github-variable delete ORG_VAR --org myorg` - 删除组织 variable

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出 variables**: `gh variable list --json <fields>`
2. **获取 variable**: `gh variable get <name> --json <fields>`
3. **设置 variable**: `gh variable set <name> --body <value> --env <env> --org <org>`
4. **删除 variable**: `gh variable delete <name> --env <env> --org <org>`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、值、作用域、更新时间
- **详情输出**: 显示名称、值、可见性、使用范围
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 设置应用配置
```
# 设置应用名称和版本
/github-variable set APP_NAME --body "MyApplication"
/github-variable set APP_VERSION --body "1.0.0"
/github-variable set APP_ENV --body "production"

# 设置服务端配置
/github-variable set SERVER_URL --body "https://api.example.com"
/github-variable set API_VERSION --body "v2"
/github-variable set MAX_CONNECTIONS --body "100"
```

### 场景 2: 环境相关配置
```
# 开发环境
/github-variable set NODE_ENV --body "development" --env development
/github-variable set DEBUG --body "true" --env development
/github-variable set LOG_LEVEL --body "debug" --env development

# 生产环境
/github-variable set NODE_ENV --body "production" --env production
/github-variable set DEBUG --body "false" --env production
/github-variable set LOG_LEVEL --body "warn" --env production
```

### 场景 3: 构建配置
```
# 设置构建参数
/github-variable set BUILD_TARGET --body "linux-amd64"
/github-variable set DOCKER_IMAGE --body "myapp"
/github-variable set DOCKER_TAG --body "latest"

# 设置语言/区域配置
/github-variable set LANG --body "en_US.UTF-8"
/github-variable set TIMEZONE --body "UTC"
```

### 场景 4: 组织级别 Variables
```
# 设置组织级别的 variable（所有仓库可用）
/github-variable set COMPANY_NAME --body "Acme Corp" --org myorg

# 设置组织 variable 仅特定仓库可用
/github-variable set DEPLOY_REGION \
  --body "us-east-1" \
  --org myorg \
  --visibility selected \
  --repositories web-app,api-server
```

### 场景 5: 管理 Variables
```
# 查看所有 variables
/github-variable list

# 查看特定 variable
/github-variable get APP_NAME

# 更新 variable
/github-variable set APP_NAME --body "NewAppName"

# 删除不需要的 variable
/github-variable delete OLD_VAR
```

### 场景 6: 批量设置相关 Variables
```
# 设置 Docker 相关配置
/github-variable set DOCKER_REGISTRY --body "ghcr.io"
/github-variable set DOCKER_USERNAME --body "username"
/github-variable set DOCKER_IMAGE_NAME --body "my-app"

# 设置 Kubernetes 相关配置
/github-variable set K8S_NAMESPACE --body "production"
/github-variable set K8S_REPLICAS --body "3"
/github-variable set K8S_IMAGE_PULL_POLICY --body "Always"
```

## Secret 与 Variable 的区别

| 特性 | Secret | Variable |
|------|--------|----------|
| **用途** | 敏感信息（密码、密钥） | 非敏感配置（名称、版本） |
| **加密** | 加密存储 | 明文存储 |
| **日志显示** | 自动脱敏 | 正常显示 |
| **大小限制** | 64KB | 64KB |
| **访问权限** | 需要更高权限 | 相对较低权限 |

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **安全性**:
   - 不要在 variable 中存储敏感信息
   - 敏感数据请使用 secret
   - variable 值在日志中不会被脱敏

2. **可见性级别**（组织 variables）:
   - `all`: 组织内所有仓库
   - `private`: 仅私有仓库
   - `selected`: 指定仓库

3. **命名规则**:
   - 通常使用大写字母
   - 可以包含字母、数字、下划线
   - 不能包含空格或特殊字符

4. **数量限制**:
   - 每个仓库最多 100 个 variables
   - 每个组织最多 1000 个 variables

5. **值限制**:
   - 每个 variable 最大 64KB
   - 不支持多行值

## 最佳实践

### 1. 命名规范
```
# 使用描述性的大写名称
APP_NAME           # 好
DATABASE_URL       # 好
DOCKER_IMAGE_NAME  # 好

# 避免模糊命名
VAR1               # 不好
VALUE              # 不好
```

### 2. 环境分离
```
# 不同环境使用不同的 variable
DEV_DATABASE_URL
STAGING_DATABASE_URL
PROD_DATABASE_URL
```

### 3. 版本管理
```
# 使用 variable 管理版本
APP_VERSION=1.0.0
API_VERSION=v2
```

### 4. 文档化
```
# 在 README 中记录 variables
# 名称          描述                示例值
# APP_NAME      应用程序名称        MyApp
# APP_VERSION   应用程序版本        1.0.0
# SERVER_URL    服务器地址          https://api.example.com
```

## 与 GitHub Actions 集成

设置 variables 后，在 workflow 中使用：

```yaml
# .github/workflows/deploy.yml
name: Deploy
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: |
          echo "Building $APP_NAME version $APP_VERSION"
          docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
        env:
          APP_NAME: ${{ vars.APP_NAME }}
          APP_VERSION: ${{ vars.APP_VERSION }}
          DOCKER_IMAGE: ${{ vars.DOCKER_IMAGE }}
          DOCKER_TAG: ${{ vars.DOCKER_TAG }}
          NODE_ENV: ${{ vars.NODE_ENV }}
```

## 在 workflow 中使用变量

```yaml
# 直接使用（无需 env 声明）
- name: Use variables
  run: |
    echo "App: ${{ vars.APP_NAME }}"
    echo "Version: ${{ vars.APP_VERSION }}"
    echo "Environment: ${{ vars.NODE_ENV }}"

# 通过 env 使用
- name: Build with variables
  env:
    APP_NAME: ${{ vars.APP_NAME }}
    APP_VERSION: ${{ vars.APP_VERSION }}
  run: |
    echo "Building $APP_NAME $APP_VERSION"
```
