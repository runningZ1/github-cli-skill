---
name: github-cli
description: GitHub CLI 技能包 - 通过自然语言执行 GitHub 仓库、PR、Issue 等操作
version: 3.0.0
---

# GitHub CLI Skills

这是一套基于 GitHub CLI (`gh`) 的模块化 Agent Skills，让你可以通过自然语言交互来执行 GitHub 操作。

**注意：** 所有脚本均已转换为 PowerShell 格式 (.ps1)，在 Windows 上原生运行。

## 配置步骤

### 1. 获取 GitHub Token

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 选择以下 scopes:
   - `repo` - 完整控制私有仓库
   - `workflow` - 运行工作流
   - `read:org` - 读取组织信息
   - `gist` - 管理 Gist
4. 生成并复制 Token

### 2. 配置 Token

```powershell
# 复制配置模板
Copy-Item ~/.claude/skills/github-cli/.env.example ~/.claude/skills/github-cli/.env

# 编辑 .env 文件，填入你的 GitHub Token
```

### 3. 验证安装

```powershell
powershell -ExecutionPolicy Bypass -File ~/.claude/skills/github-cli/scripts/verify-install.ps1
```

## 可用技能

### 核心功能 (Phase 1 & 2)

| 技能 | 描述 | 命令示例 |
|------|------|----------|
| `/github-repo` | 仓库管理 | `/github-repo create my-project --private` |
| `/github-pr` | Pull Request 管理 | `/github-pr create --title "Fix bug"` |
| `/github-issue` | Issue 管理 | `/github-issue create --title "Bug report"` |

### Phase 3: P0 核心功能

| 技能 | 描述 | 命令示例 |
|------|------|----------|
| `/github-workflow` | Actions 工作流管理 | `/github-workflow run ci.yml --ref main` |
| `/github-run` | Actions 运行记录管理 | `/github-run list --status failure` |
| `/github-release` | Release 管理 | `/github-release create v1.0.0 --title "Release"` |
| `/github-label` | 标签管理 | `/github-label create --name bug --color d73a4a` |
| `/github-secret` | Secrets 管理 | `/github-secret set API_KEY --body "xxx"` |
| `/github-variable` | Variables 管理 | `/github-variable set APP_NAME --body "MyApp"` |
| `/github-gist` | Gist 管理 | `/github-gist create script.py --desc "My Script"` |

### Phase 3: P1 常用功能

| 技能 | 描述 | 命令示例 |
|------|------|----------|
| `/github-browse` | 浏览器打开 | `/github-browse 123` |
| `/github-auth` | 认证管理 | `/github-auth login` |
| `/github-org` | 组织管理 | `/github-org list` |
| `/github-search` | 搜索 | `/github-search repos python` |
| `/github-api` | API 调用 | `/github-api get /user` |
| `/github-config` | 配置管理 | `/github-config set git_protocol ssh` |
| `/github-extension` | 扩展管理 | `/github-extension install cli/gh-extensions` |
| `/github-status` | 综合状态 | `/github-status` |
| `/github-project` | Projects 管理 | `/github-project list --owner cli` |

### Phase 3: P2 专业功能

| 技能 | 描述 | 命令示例 |
|------|------|----------|
| `/github-cache` | Actions 缓存 | `/github-cache list` |
| `/github-ssh-key` | SSH 密钥管理 | `/github-ssh-key add ~/.ssh/id_rsa.pub` |
| `/github-gpg-key` | GPG 密钥管理 | `/github-gpg-key add key.asc` |
| `/github-ruleset` | 规则集管理 | `/github-ruleset list` |
| `/github-attestation` | 认证验证 | `/github-attestation verify app.exe` |
| `/github-alias` | 别名管理 | `/github-alias set co pr checkout` |
| `/github-codespace` | Codespaces 管理 | `/github-codespace create` |
| `/github-star` | Star 管理 | `/github-star list --limit 10` |

## /github-repo 技能详情

### 支持的操作

#### 创建仓库
```
/github-repo create <名称> [--public|--private] [--description "xxx"]
```

#### 克隆仓库
```
/github-repo clone <owner/repo> [--directory <dir>]
```

#### 查看仓库信息
```
/github-repo view [owner/repo] [--web]
```

#### Fork 仓库
```
/github-repo fork <owner/repo> [--clone]
```

#### 同步仓库
```
/github-repo sync [owner/repo]
```

#### 提交更新
```
/github-repo commit "<message>" [--push] [--branch <name>]
```

#### 仓库列表
```
/github-repo list [--visibility all|public|private] [--limit <n>]
```

详细文档：[commands/github-repo.md](commands/github-repo.md)

## 脚本工具

### auth-manager.ps1 (PowerShell)

```powershell
# 加载环境变量
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 verify

# 交互式配置
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 setup

# 显示帮助
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 help
```

### output-formatter.ps1 (PowerShell)

```powershell
# 格式化仓库列表
gh repo list --json | powershell -File ~/.claude/skills/github-cli/lib/output-formatter.ps1 repo-list

# 格式化仓库详情
gh repo view --json | powershell -File ~/.claude/skills/github-cli/lib/output-formatter.ps1 repo-view

# 格式化 PR 列表
gh pr list --json | powershell -File ~/.claude/skills/github-cli/lib/output-formatter.ps1 pr-list
```

## 目录结构

```
~/.claude/skills/github-cli/
├── SKILL.md                           # 本文件
├── README.md                          # 详细文档
├── .env.example                       # 认证配置模板
├── .env                               # 认证配置（需自行创建）
├── commands/                          # 技能命令
│   ├── github-repo.md                 # 仓库管理
│   ├── github-pr.md                   # PR 管理
│   ├── github-issue.md                # Issue 管理
│   ├── github-workflow.md             # Actions 工作流管理
│   ├── github-run.md                  # Actions 运行记录管理
│   ├── github-release.md              # Release 管理
│   ├── github-label.md                # 标签管理
│   ├── github-secret.md               # Secrets 管理
│   ├── github-variable.md             # Variables 管理
│   ├── github-gist.md                 # Gist 管理
│   ├── github-browse.md               # 浏览器打开
│   ├── github-auth.md                 # 认证管理
│   ├── github-org.md                 # 组织管理
│   ├── github-search.md               # 搜索
│   ├── github-api.md                  # API 调用
│   ├── github-config.md               # 配置管理
│   ├── github-extension.md            # 扩展管理
│   ├── github-status.md               # 综合状态
│   ├── github-project.md              # Projects 管理
│   ├── github-cache.md                # Actions 缓存
│   ├── github-ssh-key.md              # SSH 密钥管理
│   ├── github-gpg-key.md              # GPG 密钥管理
│   ├── github-ruleset.md              # 规则集管理
│   ├── github-attestation.md          # 认证验证
│   ├── github-alias.md                # 别名管理
│   ├── github-codespace.md            # Codespaces 管理
│   └── github-star.md                 # Star 管理
├── lib/                               # 共享库 (PowerShell)
│   ├── auth-manager.ps1              # 认证管理
│   └── output-formatter.ps1          # 输出格式化
└── scripts/                           # 辅助脚本
    └── verify-install.ps1            # 环境验证
```

## 开发路线图

### Phase 1: 基础框架 ✅ 已完成

- [x] 安装 gh CLI
- [x] 创建目录结构
- [x] 认证管理脚本 (PowerShell)
- [x] 输出格式化脚本 (PowerShell)
- [x] 环境验证脚本 (PowerShell)
- [x] github-repo 技能

### Phase 2: PR/Issue 管理 ✅ 已完成

- [x] github-pr 技能
- [x] github-issue 技能

### Phase 3: 高级功能 ✅ 已完成

**P0 核心功能:**
- [x] github-workflow 技能
- [x] github-run 技能
- [x] github-release 技能
- [x] github-label 技能
- [x] github-secret 技能
- [x] github-variable 技能
- [x] github-gist 技能

**P1 常用功能:**
- [x] github-browse 技能
- [x] github-auth 技能
- [x] github-org 技能
- [x] github-search 技能
- [x] github-api 技能
- [x] github-config 技能
- [x] github-extension 技能
- [x] github-status 技能
- [x] github-project 技能

**P2 专业功能:**
- [x] github-cache 技能
- [x] github-ssh-key 技能
- [x] github-gpg-key 技能
- [x] github-ruleset 技能
- [x] github-attestation 技能
- [x] github-alias 技能
- [x] github-codespace 技能

### Phase 4: 完整覆盖 ✅ 已完成

Phase 3 开发完成后，已覆盖 **24/24** 所有 gh CLI 核心命令，实现 **100%** 功能覆盖！

## 参考资源

- [GitHub CLI 官方文档](https://cli.github.com/manual/)
- [GitHub CLI GitHub 仓库](https://github.com/cli/cli)
