---
name: github-label
description: 通过自然语言执行 GitHub 标签管理（创建、编辑、删除、列表、克隆）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub 标签管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 完整控制私有仓库

## 支持的操作

### 1. 列出标签

```
/github-label list [--sort name|color|created|updated] [--order asc|desc] [--limit <n>]
```

**示例：**
- `/github-label list` - 列出所有标签
- `/github-label list --limit 20` - 列出前 20 个标签
- `/github-label list --sort color --order asc` - 按颜色排序

### 2. 查看标签详情

```
/github-label view <label-name>
```

**示例：**
- `/github-label view bug` - 查看 bug 标签
- `/github-label view "priority: high"` - 查看带空格的标签

### 3. 创建标签

```
/github-label create --name <name> --color <color> [--description <description>]
```

**示例：**
- `/github-label create --name bug --color d73a4a --description "Something isn't working"`
- `/github-label create --name "priority: high" --color ee0701`
- `/github-label create --name "good first issue" --color 7057ff`

### 4. 编辑标签

```
/github-label edit <label-name> [--name <new-name>] [--color <color>] [--description <description>]
```

**示例：**
- `/github-label edit bug --color ff0000` - 修改颜色
- `/github-label edit "priority: high" --description "High priority items"` - 修改描述
- `/github-label edit feature --name enhancement` - 重命名

### 5. 删除标签

```
/github-label delete <label-name>
```

**示例：**
- `/github-label delete bug` - 删除 bug 标签
- `/github-label delete "wontfix"` - 删除 wontfix 标签

### 6. 克隆标签

```
/github-label clone <source-repo>
```

**示例：**
- `/github-label clone cli/cli` - 从 cli/cli 仓库克隆标签
- `/github-label clone owner/repo --source-only` - 仅查看不克隆

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出标签**: `gh label list --json <fields> --limit <n> --sort <field> --order <order>`
2. **查看标签**: `gh label view <label> --json <fields>`
3. **创建标签**: `gh label create --name <name> --color <color> --description <desc>`
4. **编辑标签**: `gh label edit <label> --name <new-name> --color <color> --description <desc>`
5. **删除标签**: `gh label delete <label>`
6. **克隆标签**: `gh label clone <owner/repo>`

## 输出格式化

- **列表输出**: Markdown 表格，显示名称、颜色、描述、使用数量
- **详情输出**: 显示名称、颜色十六进制、描述、创建时间
- **颜色显示**: 同时显示十六进制值和色块预览
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 初始化常用标签体系
```
# 创建 bug 相关标签
/github-label create --name bug --color d73a4a --description "Something isn't working"
/github-label create --name "critical bug" --color b60205 --description "Critical bug"

# 创建功能相关标签
/github-label create --name enhancement --color a2eeef --description "New feature or request"
/github-label create --name feature --color 0e8a16 --description "New feature"

# 创建优先级标签
/github-label create --name "priority: critical" --color b60205
/github-label create --name "priority: high" --color ee0701
/github-label create --name "priority: medium" --color ffaa00
/github-label create --name "priority: low" --color 0e8a16

# 创建状态标签
/github-label create --name "wontfix" --color ffffff --description "This will not be worked on"
/github-label create --name duplicate --color cfd3d7 --description "This is a duplicate"
/github-label create --name "in progress" --color 0075ca --description "Being worked on"

# 创建难度标签
/github-label create --name "good first issue" --color 7057ff --description "Good for newcomers"
/github-label create --name "help wanted" --color 008672 --description "Extra attention is needed"
```

### 场景 2: 批量管理标签
```
# 列出所有标签
/github-label list

# 按颜色排序查看
/github-label list --sort color --order asc

# 查看特定标签
/github-label view "priority: high"
```

### 场景 3: 编辑标签
```
# 修改标签颜色
/github-label edit bug --color ff0000

# 修改标签描述
/github-label edit enhancement --description "New feature or enhancement"

# 重命名标签
/github-label edit "new feature" --name enhancement
```

### 场景 4: 从知名项目克隆标签
```
# 从 React 项目克隆标签体系
/github-label clone facebook/react

# 从 VS Code 项目克隆
/github-label clone microsoft/vscode
```

### 场景 5: 清理无用标签
```
# 查看所有标签
/github-label list

# 删除不需要的标签
/github-label delete "old label"
```

## 常用标签颜色参考

| 用途 | 颜色 | 十六进制 |
|------|------|----------|
| Bug (红色) | ![#d73a4a](https://via.placeholder.com/15/d73a4a/000000?text=+) | `d73a4a` |
| 增强 (蓝色) | ![#a2eeef](https://via.placeholder.com/15/a2eeef/000000?text=+) | `a2eeef` |
| 功能 (绿色) | ![#0e8a16](https://via.placeholder.com/15/0e8a16/000000?text=+) | `0e8a16` |
| 高优先级 (深红) | ![#ee0701](https://via.placeholder.com/15/ee0701/000000?text=+) | `ee0701` |
| 低优先级 (浅绿) | ![#0e8a16](https://via.placeholder.com/15/0e8a16/000000?text=+) | `0e8a16` |
| 适合新手 (紫色) | ![#7057ff](https://via.placeholder.com/15/7057ff/000000?text=+) | `7057ff` |
| 进行中 (蓝色) | ![#0075ca](https://via.placeholder.com/15/0075ca/000000?text=+) | `0075ca` |
| 无效 (灰色) | ![#cfd3d7](https://via.placeholder.com/15/cfd3d7/000000?text=+) | `cfd3d7` |

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **颜色格式**: 支持 6 位十六进制，不带 `#`
2. **标签命名**: 使用冒号分隔层级如 `priority: high`
3. **描述长度**: 标签描述最多 200 字符
4. **标签数量**: 每个仓库最多 1000 个标签
5. **名称唯一**: 标签名称在同一仓库内必须唯一

## 推荐的标签体系

### 按类型分类
```
bug
feature
enhancement
documentation
question
```

### 按优先级分类
```
priority: critical
priority: high
priority: medium
priority: low
```

### 按状态分类
```
status: triage
status: confirmed
status: in progress
status: blocked
status: ready for review
```

### 按难度分类
```
good first issue
help wanted
effort: small
effort: medium
effort: large
```
