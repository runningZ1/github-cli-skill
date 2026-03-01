---
name: github-config
description: 通过自然语言管理 GitHub CLI 配置（查看、设置、清除缓存）
version: 1.0.0
argument-hint: [operation] [key] [value]
allowed-tools: Bash(*)
---

# GitHub CLI 配置管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

## 支持的操作

### 1. 列出配置

```
/github-config list
```

**示例：**
- `/github-config list` - 列出所有配置项

### 2. 获取配置值

```
/github-config get <key>
```

**示例：**
- `/github-config get git_protocol` - 获取 git 协议设置
- `/github-config get editor` - 获取编辑器设置
- `/github-config get pager` - 获取分页器设置

### 3. 设置配置值

```
/github-config set <key> <value>
```

**示例：**
- `/github-config set git_protocol ssh` - 设置 git 协议为 SSH
- `/github-config set editor vim` - 设置编辑器
- `/github-config set prompt disabled` - 禁用交互提示

### 4. 清除缓存

```
/github-config clear-cache
```

**示例：**
- `/github-config clear-cache` - 清除 CLI 缓存

## 可配置项

| 键 | 描述 | 可选值 | 默认值 |
|----|------|--------|--------|
| `git_protocol` | git 克隆和推送的协议 | `https`, `ssh` | `https` |
| `editor` | 文本编辑器 | 任意编辑器命令 | - |
| `prompt` | 交互提示 | `enabled`, `disabled` | `enabled` |
| `prefer_editor_prompt` | 编辑器提示偏好 | `enabled`, `disabled` | `disabled` |
| `pager` | 分页器 | 任意分页器命令 | - |
| `http_unix_socket` | Unix socket 路径 | 路径 | - |
| `browser` | 浏览器 | 浏览器命令 | - |
| `color_labels` | 彩色标签 | `enabled`, `disabled` | `disabled` |
| `accessible_colors` | 无障碍颜色 | `enabled`, `disabled` | `disabled` |
| `accessible_prompter` | 无障碍提示 | `enabled`, `disabled` | `disabled` |
| `spinner` | 动画进度指示 | `enabled`, `disabled` | `enabled` |

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出配置**: `gh config list`
2. **获取配置**: `gh config get <key>`
3. **设置配置**: `gh config set <key> <value>`
4. **清除缓存**: `gh config clear-cache`

## 输出格式化

- **列表输出**: Markdown 表格，显示键和值
- **单个值**: 直接显示值
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load
```

## 使用场景

### 场景 1: 查看当前配置
```
# 列出所有配置
/github-config list

# 查看特定配置
/github-config get git_protocol
```

### 场景 2: 设置偏好
```
# 使用 SSH 协议
/github-config set git_protocol ssh

# 设置编辑器
/github-config set editor "code --wait"

# 禁用交互提示（适合脚本）
/github-config set prompt disabled
```

### 场景 3: 清除缓存
```
# 清除 CLI 缓存（遇到问题时）
/github-config clear-cache
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **配置位置**:
   - Windows: `%AppData%\GitHub CLI\config.yml`
   - macOS: `~/.config/gh/config.yml`
   - Linux: `~/.config/gh/config.yml`

2. **主机特定配置**: 可为不同 GitHub 主机设置不同配置

3. **环境变量优先级**: 环境变量 > 配置文件 > 默认值
