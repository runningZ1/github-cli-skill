---
name: github-browse
description: 通过自然语言在浏览器中打开 GitHub 页面（仓库、issue、PR、settings 等）
version: 1.0.0
argument-hint: [location] [options]
allowed-tools: Bash(*)
---

# GitHub 浏览器打开技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- 无需特殊权限（仅打开浏览器）

## 支持的操作

### 1. 打开仓库首页

```
/github-browse
```

**示例：**
- `/github-browse` - 打开当前仓库首页
- `/github-browse --repo owner/repo` - 打开指定仓库

### 2. 打开 Issue 或 PR

```
/github-browse <number>
```

**示例：**
- `/github-browse 123` - 打开 issue/PR #123
- `/github-browse 456 --repo owner/repo` - 打开指定仓库的 #456

### 3. 打开文件

```
/github-browse <path/to/file>
```

**示例：**
- `/github-browse src/main.py` - 打开特定文件
- `/github-browse README.md` - 打开 README

### 4. 打开特定分支

```
/github-browse --branch <branch-name>
```

**示例：**
- `/github-browse --branch feature/new-feature`
- `/github-browse src/main.py --branch develop`

### 5. 打开特定 Commit

```
/github-browse --commit <commit-sha>
```

**示例：**
- `/github-browse --commit abc1234`
- `/github-browse --commit HEAD`

### 6. 打开特殊页面

```
/github-browse --settings | --wiki | --releases | --projects | --actions
```

**示例：**
- `/github-browse --settings` - 打开仓库设置
- `/github-browse --wiki` - 打开 Wiki
- `/github-browse --releases` - 打开 Releases 页面
- `/github-browse --projects` - 打开 Projects 页面
- `/github-browse --actions` - 打开 Actions 页面

### 7. 仅显示 URL

```
/github-browse --no-browser
```

**示例：**
- `/github-browse --no-browser` - 仅打印 URL，不打开浏览器
- `/github-browse 123 --no-browser` - 打印 issue URL

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **打开仓库**: `gh browse`
2. **打开 issue/PR**: `gh browse <number>`
3. **打开文件**: `gh browse <path>`
4. **打开分支**: `gh browse --branch <branch>`
5. **打开 commit**: `gh browse --commit <sha>`
6. **打开设置**: `gh browse --settings`
7. **仅 URL**: `gh browse --no-browser`

## 输出格式化

- **成功**: 显示打开的 URL 和页面类型
- **仅 URL 模式**: 显示完整 URL
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load
```

## 使用场景

### 场景 1: 快速查看仓库
```
# 打开当前仓库
/github-browse

# 打开指定仓库
/github-browse --repo octocat/Hello-World
```

### 场景 2: 查看 Issue/PR
```
# 打开当前仓库的 #123
/github-browse 123

# 打开指定仓库的 #456
/github-browse 456 --repo owner/repo
```

### 场景 3: 查看文件
```
# 打开 README
/github-browse README.md

# 打开特定分支的文件
/github-browse src/main.py --branch develop
```

### 场景 4: 访问功能页面
```
# 打开设置页面
/github-browse --settings

# 打开 Actions 页面
/github-browse --actions

# 打开 Releases 页面
/github-browse --releases
```

### 场景 5: 获取 URL
```
# 获取 URL 但不打开（用于分享）
/github-browse --no-browser

# 获取特定 issue 的 URL
/github-browse 123 --no-browser
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **浏览器**: 使用系统默认浏览器
2. **环境变量**: 可使用 `BROWSER` 环境变量自定义浏览器
3. **权限**: 访问私有仓库需要相应权限
4. **远程仓库**: 需要已配置 git remote
