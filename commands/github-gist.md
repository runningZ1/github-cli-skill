---
name: github-gist
description: 通过自然语言执行 GitHub Gist 管理（创建、查看、编辑、删除、克隆）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Gist 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `gist` - 管理 Gist

## 支持的操作

### 1. 列出 Gists

```
/github-gist list [--visibility public|secret] [--limit <n>]
```

**示例：**
- `/github-gist list` - 列出所有 gists
- `/github-gist list --visibility public --limit 10` - 列出公共 gists
- `/github-gist list --visibility secret` - 列出秘密 gists

### 2. 查看 Gist

```
/github-gist view <gist-id|gist-url> [--filename <filename>]
```

**示例：**
- `/github-gist view 5b0e0062eb8e9654adad7bb1d81cc75f` - 查看 gist
- `/github-gist view https://gist.github.com/5b0e0062eb8e9654adad7bb1d81cc75f` - 通过 URL 查看
- `/github-gist view 5b0e0062eb8e9654adad7bb1d81cc75f --filename README.md` - 查看特定文件

### 3. 创建 Gist

```
/github-gist create <files...> [--desc "description"] [--public]
```

**示例：**
- `/github-gist create script.py --desc "My Python Script"` - 创建私有 gist
- `/github-gist create script.py --desc "Public Script" --public` - 创建公共 gist
- `/github-gist create file1.py file2.js --desc "Multiple Files"` - 创建多文件 gist

### 4. 编辑 Gist

```
/github-gist edit <gist-id|gist-url> [--filename <filename>] [--add <file>] [--remove <filename>]
```

**示例：**
- `/github-gist edit 5b0e0062eb8e9654adad7bb1d81cc75f --filename script.py` - 编辑文件
- `/github-gist edit 5b0e0062eb8e9654adad7bb1d81cc75f --add newfile.js` - 添加文件
- `/github-gist edit 5b0e0062eb8e9654adad7bb1d81cc75f --remove oldfile.txt` - 删除文件

### 5. 删除 Gist

```
/github-gist delete <gist-id|gist-url>
```

**示例：**
- `/github-gist delete 5b0e0062eb8e9654adad7bb1d81cc75f` - 删除 gist
- `/github-gist delete https://gist.github.com/5b0e0062eb8e9654adad7bb1d81cc75f` - 通过 URL 删除

### 6. 克隆 Gist

```
/github-gist clone <gist-id|gist-url> [<directory>]
```

**示例：**
- `/github-gist clone 5b0e0062eb8e9654adad7bb1d81cc75f` - 克隆到当前目录
- `/github-gist clone 5b0e0062eb8e9654adad7bb1d81cc75f my-gist` - 克隆到指定目录

### 7. 重命名 Gist 文件

```
/github-gist rename <gist-id|gist-url> <old-filename> <new-filename>
```

**示例：**
- `/github-gist rename 5b0e0062eb8e9654adad7bb1d81cc75f script.py new-script.py` - 重命名文件

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出 gists**: `gh gist list --json <fields> --limit <n> --visibility <type>`
2. **查看 gist**: `gh gist view <gist> --json <fields>`
3. **创建 gist**: `gh gist create <files> --desc <desc> --public`
4. **编辑 gist**: `gh gist edit <gist> --filename <file> --add <file> --remove <file>`
5. **删除 gist**: `gh gist delete <gist>`
6. **克隆 gist**: `gh gist clone <gist> [<dir>]`
7. **重命名**: `gh gist rename <gist> <old> <new>`

## 输出格式化

- **列表输出**: Markdown 表格，显示 ID、描述、文件数量、可见性、更新时间
- **详情输出**: 显示描述、文件列表、创建时间、更新时间
- **文件内容**: 语法高亮显示代码
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 快速分享代码片段
```
# 创建单个文件的 gist
/github-gist create hello.py --desc "Hello World in Python"

# 创建公共 gist 分享给他人
/github-gist create util.js --desc "JavaScript Utilities" --public
```

### 场景 2: 创建多文件 gist
```
# 创建包含多个相关文件的 gist
/github-gist create main.py utils.py config.py --desc "Python Project Structure"

# 创建完整的示例项目
/github-gist create index.html style.css script.js --desc "Frontend Demo" --public
```

### 场景 3: 管理和编辑 gist
```
# 查看所有 gists
/github-gist list

# 查看特定 gist
/github-gist view 5b0e0062eb8e9654adad7bb1d81cc75f

# 编辑 gist 添加新文件
/github-gist edit 5b0e0062eb8e9654adad7bb1d81cc75f --add README.md

# 删除不需要的文件
/github-gist edit 5b0e0062eb8e9654adad7bb1d81cc75f --remove old-file.txt
```

### 场景 4: 克隆 gist 到本地
```
# 克隆自己的 gist
/github-gist clone 5b0e0062eb8e9654adad7bb1d81cc75f

# 克隆他人的公共 gist
/github-gist clone https://gist.github.com/octocat/5b0e0062eb8e9654adad7bb1d81cc75f

# 克隆到指定目录
/github-gist clone 5b0e0062eb8e9654adad7bb1d81cc75f snippets/python
```

### 场景 5: 清理 gist
```
# 列出所有 gists 查看
/github-gist list

# 删除不需要的 gist
/github-gist delete 5b0e0062eb8e9654adad7bb1d81cc75f
```

### 场景 6: 从 stdin 创建 gist
```
# 管道输入创建 gist
echo "print('Hello')" | /github-gist create - --desc "Python One-liner"

# 从文件创建
/github-gist create ./path/to/file.py --desc "My Script"
```

## Gist 可见性说明

| 可见性 | 描述 | 访问权限 |
|--------|------|----------|
| **Public (公共)** | 在 Gist 首页显示，可被搜索 | 任何人都可以查看 |
| **Secret (秘密)** | 不在 Gist 首页显示，不可被搜索 | 有链接的人可以查看 |

**注意**: Secret 不等于私有，任何有链接的人都可以访问。

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具
- `git` - Git 版本控制（用于 clone）

## 注意事项

1. **文件大小**: 单个文件最大 10MB
2. **文件数量**: 每个 gist 最多 100 个文件
3. **可见性**: Public 可被搜索，Secret 不可被搜索但有链接即可访问
4. **Gist ID**: 可以从 URL 中提取，格式为 `https://gist.github.com/[user]/<gist-id>`
5. **匿名创建**: 不登录也可以创建 gist，但无法管理

## 与代码片段管理集成

### 保存常用脚本
```bash
# 保存常用的 shell 脚本
/github-gist create dotfiles.sh --desc "Dotfiles Setup Script" --public

# 保存配置模板
/github-gist create .gitignore --desc "Python .gitignore Template" --public

# 保存代码片段
/github-gist create snippets.py --desc "Python Snippets" --public
```

### 分享配置示例
```bash
# 分享 VS Code 配置
/github-gist create settings.json keybindings.json --desc "VS Code Config" --public

# 分享 Docker 配置
/github-gist create Dockerfile docker-compose.yml --desc "Docker Setup" --public
```

## 最佳实践

### 1. 描述清晰
```
# 好的描述
"Python Data Processing Utilities for CSV files"

# 模糊的描述
"my script"
```

### 2. 文件命名
```
# 使用有意义的文件名
data_processor.py
config.example.json
README.md

# 避免使用默认名
gistfile1.txt
```

### 3. 添加文档
```
# 创建 gist 时包含 README
/github-gist create script.py README.md --desc "Complete Project"
```

### 4. 版本管理
```
# gist 支持版本历史
# 编辑 gist 后可以查看历史版本
/github-gist view 5b0e0062eb8e9654adad7bb1d81cc75f
```
