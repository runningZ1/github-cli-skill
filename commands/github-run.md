---
name: github-run
description: 通过自然语言执行 GitHub Actions 运行记录管理（查看、重试、取消、下载）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Actions 运行记录管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 访问私有仓库
- `workflow` - 访问工作流运行

## 支持的操作

### 1. 列出运行记录

```
/github-run list [--workflow <workflow>] [--status success|failure|skipped|in_progress] [--limit <n>]
```

**示例：**
- `/github-run list` - 列出最近的运行记录
- `/github-run list --workflow ci.yml --limit 10` - 列出 CI 的最近运行
- `/github-run list --status failure` - 列出失败的运行

### 2. 查看运行详情

```
/github-run view <run-id> [--job <job-name>]
```

**示例：**
- `/github-run view 12345678` - 查看指定运行
- `/github-run view 12345678 --job build` - 查看特定 job

### 3. 监控运行状态

```
/github-run watch <run-id>
```

**示例：**
- `/github-run watch 12345678` - 实时监控运行直到完成

### 4. 重新运行

```
/github-run rerun <run-id> [--failed]
```

**示例：**
- `/github-run rerun 12345678` - 重新运行
- `/github-run rerun 12345678 --failed` - 仅重试失败的 job

### 5. 取消运行

```
/github-run cancel <run-id>
```

**示例：**
- `/github-run cancel 12345678` - 取消正在运行的工作流

### 6. 删除运行记录

```
/github-run delete <run-id>
```

**示例：**
- `/github-run delete 12345678` - 删除运行记录

### 7. 下载 Artifacts

```
/github-run download <run-id> [--pattern <pattern>] [--dir <directory>]
```

**示例：**
- `/github-run download 12345678` - 下载所有 artifacts
- `/github-run download 12345678 --pattern "*.zip"` - 下载特定文件
- `/github-run download 12345678 --dir ./downloads` - 下载到指定目录

### 8. 查看运行日志

```
/github-run logs <run-id> [--job <job-name>]
```

**示例：**
- `/github-run logs 12345678` - 查看所有日志
- `/github-run logs 12345678 --job build` - 查看特定 job 日志

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出运行**: `gh run list --json <fields> --limit <n> --workflow <workflow>`
2. **查看运行**: `gh run view <run-id> --json <fields>`
3. **监控运行**: `gh run watch <run-id>`
4. **重新运行**: `gh run rerun <run-id> --failed`
5. **取消运行**: `gh run cancel <run-id>`
6. **删除运行**: `gh run delete <run-id>`
7. **下载 artifacts**: `gh run download <run-id> --pattern <pattern> --dir <dir>`
8. **查看日志**: `gh run logs <run-id> --job <job>`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、工作流名称、状态、分支、时间
- **运行详情**: 显示工作流、状态、持续时间、触发者、提交信息
- **监控输出**: 实时更新每个 job 的状态
- **日志输出**: 带时间戳的日志，支持 ANSI 颜色
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 查看最近的 CI 运行
```
# 列出最近的运行
/github-run list --limit 10

# 查看失败的运行
/github-run list --status failure --limit 5

# 查看特定运行详情
/github-run view 12345678
```

### 场景 2: 监控部署
```
# 触发部署后监控
/github-run watch 12345678

# 如果失败，查看日志
/github-run logs 12345678 --job deploy
```

### 场景 3: 重新运行失败的任务
```
# 列出失败的运行
/github-run list --status failure

# 重新运行失败的
/github-run rerun 12345678 --failed
```

### 场景 4: 取消错误的运行
```
# 取消正在运行的（例如推送了错误的代码）
/github-run cancel 12345678
```

### 场景 5: 下载构建产物
```
# 下载特定运行的 artifacts
/github-run download 12345678 --dir ./build-artifacts

# 下载特定类型的文件
/github-run download 12345678 --pattern "*.apk"
```

### 场景 6: 排查失败原因
```
# 查看失败运行的日志
/github-run logs 12345678

# 查看特定 job 的日志
/github-run logs 12345678 --job test
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **运行状态**: 只能取消 `in_progress` 状态的运行
2. **日志保留**: GitHub 保留日志 90 天
3. **Artifact 过期**: Artifacts 有保留期限（默认 90 天）
4. **权限要求**: 需要 `repo` 权限访问私有仓库的运行
5. **重新运行限制**: 只能重新运行 30 天内的运行
