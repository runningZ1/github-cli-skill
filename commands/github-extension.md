---
name: github-extension
description: 通过自然语言管理 GitHub CLI 扩展（安装、卸载、更新、搜索）
version: 1.0.0
argument-hint: [operation] [name] [options]
allowed-tools: Bash(*)
---

# GitHub CLI 扩展管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- 无需特殊权限（公开扩展）

## 支持的操作

### 1. 列出已安装扩展

```
/github-extension list
```

**示例：**
- `/github-extension list` - 列出所有已安装的扩展

### 2. 安装扩展

```
/github-extension install <repository>
```

**示例：**
- `/github-extension install cli/gh-extensions` - 安装官方扩展
- `/github-extension install owner/repo` - 安装指定仓库的扩展

### 3. 卸载扩展

```
/github-extension remove <name>
```

**示例：**
- `/github-extension remove gh-extensions` - 卸载扩展

### 4. 更新扩展

```
/github-extension upgrade [name] [--all]
```

**示例：**
- `/github-extension upgrade gh-extensions` - 更新特定扩展
- `/github-extension upgrade --all` - 更新所有扩展

### 5. 搜索扩展

```
/github-extension search <query>
```

**示例：**
- `/github-extension search kubernetes` - 搜索 kubernetes 相关扩展
- `/github-extension search deployment` - 搜索部署相关扩展

### 6. 创建扩展

```
/github-extension create <name>
```

**示例：**
- `/github-extension create my-extension` - 创建新扩展

### 7. 浏览扩展

```
/github-extension browse
```

**示例：**
- `/github-extension browse` - 打开扩展浏览界面

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出扩展**: `gh extension list`
2. **安装扩展**: `gh extension install <repo>`
3. **卸载扩展**: `gh extension remove <name>`
4. **更新扩展**: `gh extension upgrade <name> --all`
5. **搜索扩展**: `gh extension search <query>`
6. **创建扩展**: `gh extension create <name>`
7. **浏览扩展**: `gh extension browse`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、版本、来源
- **搜索结果**: 显示扩展名称、描述、仓库链接
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load
```

## 使用场景

### 场景 1: 发现扩展
```
# 搜索扩展
/github-extension search kubernetes

# 浏览扩展（UI）
/github-extension browse
```

### 场景 2: 安装扩展
```
# 安装官方扩展
/github-extension install cli/gh-extensions

# 安装流行扩展
/github-extension install dlvhdr/gh-dash
```

### 场景 3: 管理扩展
```
# 列出已安装扩展
/github-extension list

# 更新所有扩展
/github-extension upgrade --all

# 卸载不需要的扩展
/github-extension remove gh-extensions
```

### 场景 4: 开发扩展
```
# 创建新扩展
/github-extension create my-extension
```

## 热门扩展推荐

| 扩展 | 描述 |
|------|------|
| `gh-dash` | GitHub 仪表盘 |
| `gh-sky` | GitHub Skyline 3D 视图 |
| `gh-eco` | 查看生态相关统计 |
| `gh-voice` | 语音交互 |
| `gh-copilot` | Copilot 集成 |

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `git` - Git 版本控制

## 注意事项

1. **扩展命名**: 扩展仓库必须以 `gh-` 开头
2. **执行**: 使用 `gh extension exec <name>` 执行扩展
3. **安全**: 扩展是第三方代码，请注意审查
4. **冲突**: 扩展不能覆盖核心 gh 命令
