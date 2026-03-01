# GitHub CLI Skills

基于 GitHub CLI (`gh`) 的模块化 Agent Skills，让你可以通过自然语言交互来执行 GitHub 操作。

## 快速开始

### 1. 环境要求

- **gh CLI** v2.0+ - [安装指南](https://github.com/cli/cli#installation)
- **jq** - JSON 处理工具
- **git** - Git 版本控制
- **PowerShell** - Windows 原生支持

### 2. 配置认证

```powershell
# 复制配置模板
Copy-Item ~/.claude/skills/github-cli/.env.example ~/.claude/skills/github-cli/.env

# 编辑 .env 文件，填入你的 GitHub Token
# 获取 Token: https://github.com/settings/tokens
# 需要的 scopes: repo, workflow, read:org, gist
```

### 3. 验证配置

```powershell
# 验证环境配置
powershell -ExecutionPolicy Bypass -File ~/.claude/skills/github-cli/scripts/verify-install.ps1

# 加载环境变量
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证状态
gh auth status
```

## 可用技能

### /github-repo - 仓库管理

管理 GitHub 仓库，包括创建、克隆、查看、同步等操作。

**使用示例：**

```
/github-repo create my-project --private --description "My awesome project"
/github-repo clone octocat/Hello-World
/github-repo view
/github-repo fork owner/repo --clone
/github-repo sync
/github-repo commit "Fix bug" --push --branch feature/fix
```

**详细文档：** [commands/github-repo.md](commands/github-repo.md)

### /github-pr - Pull Request 管理

管理 GitHub Pull Request，包括创建、查看、列表、合并、评论等操作。

**使用示例：**

```
/github-pr create --title "Fix login bug" --body "Resolves #123"
/github-pr view 123
/github-pr list --state open --limit 10
/github-pr merge 123 --squash --delete-branch
/github-pr comment 123 --body "LGTM! Ready to merge"
```

**详细文档：** [commands/github-pr.md](commands/github-pr.md)

### /github-issue - Issue 管理

管理 GitHub Issue，包括创建、查看、列表、分配、标签等操作。

**使用示例：**

```
/github-issue create --title "Bug: Login fails" --label bug --assignee octocat
/github-issue view 123
/github-issue list --state open --label bug
/github-issue edit 123 --add-assignee alice
/github-issue close 123
```

**详细文档：** [commands/github-issue.md](commands/github-issue.md)

### 即将上线

### /github-workflow - Actions 工作流管理

管理 GitHub Actions 工作流，包括查看、运行、禁用等操作。

### /github-run - Actions 运行记录管理

管理 GitHub Actions 运行记录，包括查看、重新运行、下载 artifacts 等操作。

### /github-release - Release 管理

管理 GitHub Release，包括创建、查看、上传 assets 等操作。

### /github-label - 标签管理

管理 GitHub 标签，包括创建、编辑、删除、列表等操作。

## 脚本工具

### auth-manager.ps1 (PowerShell)

认证管理脚本：

```powershell
# 加载环境变量
. lib/auth-manager.ps1 load

# 验证认证状态
. lib/auth-manager.ps1 verify

# 交互式配置
. lib/auth-manager.ps1 setup

# 显示帮助
. lib/auth-manager.ps1 help
```

### output-formatter.ps1 (PowerShell)

输出格式化脚本：

```powershell
# 格式化仓库列表
gh repo list --json | powershell -File lib/output-formatter.ps1 repo-list

# 格式化仓库详情
gh repo view --json | powershell -File lib/output-formatter.ps1 repo-view

# 格式化 PR 列表
gh pr list --json | powershell -File lib/output-formatter.ps1 pr-list
```

## 开发计划

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

### Phase 3: 高级功能 (计划中)

- [ ] github-workflow 技能
- [ ] github-run 技能
- [ ] github-release 技能
- [ ] github-label 技能

### Phase 4: 完整覆盖 (计划中)

- [ ] github-gist 技能
- [ ] github-project 技能
- [ ] github-api 技能
- [ ] github-codespace 技能

## 目录结构

```
~/.claude/skills/github-cli/
├── README.md                          # 本文件
├── SKILL.md                           # 技能说明
├── .env.example                       # 认证配置模板
├── .env                               # 认证配置（需自行创建）
├── commands/                          # 技能命令
│   ├── github-repo.md                 # 仓库管理
│   ├── github-pr.md                   # PR 管理
│   └── github-issue.md                # Issue 管理
├── lib/                               # 共享库 (PowerShell)
│   ├── auth-manager.ps1              # 认证管理
│   └── output-formatter.ps1          # 输出格式化
└── scripts/                           # 辅助脚本
    └── verify-install.ps1            # 环境验证
```

## 常见问题

### Q: 如何获取 GitHub Token？

A: 访问 https://github.com/settings/tokens，点击 "Generate new token (classic)"，选择以下 scopes:
- `repo` - 完整控制私有仓库
- `workflow` - 运行工作流
- `read:org` - 读取组织信息
- `gist` - 管理 Gist

### Q: PowerShell 执行策略限制？

A: 使用以下命令临时绕过执行策略：
```powershell
powershell -ExecutionPolicy Bypass -File script.ps1
```

或者设置执行策略：
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### Q: gh 命令找不到？

A: 在 Windows 上，安装后可能需要重启终端或刷新 PATH 环境变量。也可以手动添加：
```powershell
$env:Path += ";C:\Program Files\GitHub CLI"
```

### Q: 如何更新技能？

A: 拉取最新代码或手动更新文件：
```powershell
cd ~/.claude/skills/github-cli
git pull  # 如果使用了 git
```

## 参考资源

- [GitHub CLI 官方文档](https://cli.github.com/manual/)
- [GitHub CLI GitHub 仓库](https://github.com/cli/cli)
- [命令开发指南](../../command-development/SKILL.md)

## License

MIT
