# GitHub CLI Skills

基于 GitHub CLI (`gh`) 的模块化 Claude Code Skills，让你通过自然语言交互来执行 GitHub 操作。

## 快速开始

### 1. 安装依赖

- **gh CLI** v2.0+ - [安装指南](https://github.com/cli/cli#installation)
- **git** - Git 版本控制

### 2. 配置认证

见 [QUICKSTART.md](QUICKSTART.md)

## 可用技能

### 核心技能

| 技能 | 描述 | 示例 |
|------|------|------|
| `/github-repo` | 仓库管理 | `/github-repo create my-project --private` |
| `/github-pr` | Pull Request 管理 | `/github-pr create --title "Fix bug"` |
| `/github-issue` | Issue 管理 | `/github-issue create --title "Bug report"` |

### 完整技能列表

**仓库与代码管理**
- `/github-repo` - 仓库创建、克隆、查看、同步
- `/github-pr` - PR 创建、查看、列表、合并、评论
- `/github-issue` - Issue 创建、查看、分配、标签
- `/github-label` - 标签管理
- `/github-release` - Release 发布与管理

**Actions 工作流**
- `/github-workflow` - 工作流查看、运行
- `/github-run` - 运行记录查看、重新运行
- `/github-cache` - Actions 缓存管理

**组织与项目**
- `/github-org` - 组织管理
- `/github-project` - Projects 管理
- `/github-search` - 搜索仓库、代码、Issue

**配置与认证**
- `/github-auth` - 认证管理（登录、登出、切换）
- `/github-config` - 配置管理
- `/github-ssh-key` - SSH 密钥管理
- `/github-gpg-key` - GPG 密钥管理

**其他工具**
- `/github-gist` - Gist 管理
- `/github-api` - GitHub API 调用
- `/github-browse` - 浏览器打开
- `/github-status` - 综合状态查看
- `/github-extension` - 扩展管理
- `/github-alias` - 别名管理
- `/github-codespace` - Codespaces 管理
- `/github-secret` - Secrets 管理
- `/github-variable` - Variables 管理
- `/github-ruleset` - 规则集管理
- `/github-attestation` - 认证验证

## 目录结构

```
github-cli-skill/
├── README.md                    # 本文件
├── QUICKSTART.md                # 快速开始指南
├── SKILL.md                     # 技能详细说明
├── .env.example                 # 认证配置模板
├── commands/                    # 技能命令文档
│   ├── github-repo.md
│   ├── github-pr.md
│   ├── github-issue.md
│   └── ...
├── lib/                         # PowerShell 库
│   ├── auth-manager.ps1
│   └── output-formatter.ps1
└── scripts/                     # 辅助脚本
    └── verify-install.ps1
```

## 使用方法

1. 查看 [QUICKSTART.md](QUICKSTART.md) 完成认证配置
2. 使用 `/github-<技能>` 命令执行操作

示例：
```
/github-repo list
/github-pr create --title "Fix bug" --body "Resolves #123"
/github-issue view 42
```

详细文档见 [SKILL.md](SKILL.md)

## 参考资源

- [GitHub CLI 官方文档](https://cli.github.com/manual/)
- [GitHub CLI GitHub 仓库](https://github.com/cli/cli)

## License

MIT
