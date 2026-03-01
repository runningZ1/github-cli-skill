---
name: github-cache
description: 通过自然语言管理 GitHub Actions 缓存（查看、删除）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub Actions 缓存管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 访问私有仓库

## 支持的操作

### 1. 列出缓存

```
/github-cache list [--key <key>] [--limit <n>]
```

**示例：**
- `/github-cache list` - 列出所有缓存
- `/github-cache list --key npm-` - 列出 npm 相关缓存
- `/github-cache list --limit 20` - 列出前 20 个缓存

### 2. 删除缓存

```
/github-cache delete <cache-id|key> [--all]
```

**示例：**
- `/github-cache delete 123` - 删除指定 ID 的缓存
- `/github-cache delete npm-cache` - 删除指定 key 的缓存
- `/github-cache delete --all` - 删除所有缓存

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出缓存**: `gh cache list --json <fields> --limit <n>`
2. **删除缓存**: `gh cache delete <id|key>`
3. **删除所有**: `gh cache delete --all`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、key、大小、创建时间
- **成功状态**: 显示删除结果
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 查看缓存
```
# 列出所有缓存
/github-cache list

# 查找特定缓存
/github-cache list --key npm-
```

### 场景 2: 清理缓存
```
# 删除特定缓存
/github-cache delete npm-cache

# 删除所有缓存（清理空间）
/github-cache delete --all
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **缓存限制**: 每个仓库最多 10GB 缓存
2. **缓存过期**: 7 天未访问的缓存会自动过期
3. **分支缓存**: 每个分支的缓存是独立的
