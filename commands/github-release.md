---
name: github-release
description: 通过自然语言执行 GitHub Release 管理（创建、编辑、删除、上传 assets）
version: 1.0.0
argument-hint: [operation] [parameters...]
allowed-tools: Bash(*)
---

# GitHub Release 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token
3. 执行 `. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load` 加载环境变量

**所需权限：**
- `repo` - 完整控制私有仓库
- `workflow` - 运行工作流（如果需要自动发布）

## 支持的操作

### 1. 列出 Releases

```
/github-release list [--limit <n>]
```

**示例：**
- `/github-release list` - 列出所有 releases
- `/github-release list --limit 10` - 列出最近 10 个

### 2. 查看 Release 详情

```
/github-release view <tag>
```

**示例：**
- `/github-release view v1.0.0` - 查看指定版本
- `/github-release view latest` - 查看最新版本

### 3. 创建 Release

```
/github-release create <tag> [--title <title>] [--notes <notes>] [--draft] [--prerelease] [--target <branch>]
```

**示例：**
- `/github-release create v1.0.0 --title "Version 1.0.0" --notes "Initial release"`
- `/github-release create v2.0.0 --draft --title "WIP"` - 创建草稿
- `/github-release create v1.1.0 --prerelease --target develop` - 创建预发布版本

### 4. 编辑 Release

```
/github-release edit <tag> [--title <title>] [--notes <notes>] [--draft|--latest] [--prerelease|--not-prerelease]
```

**示例：**
- `/github-release edit v1.0.0 --title "Updated Title"`
- `/github-release edit v1.0.0 --draft false` - 发布草稿
- `/github-release edit v1.0.0 --latest` - 设为最新版本

### 5. 删除 Release

```
/github-release delete <tag>
```

**示例：**
- `/github-release delete v1.0.0` - 删除指定版本

### 6. 上传 Assets

```
/github-release upload <tag> <files...>
```

**示例：**
- `/github-release upload v1.0.0 app.exe` - 上传单个文件
- `/github-release upload v1.0.0 *.zip *.tar.gz` - 上传多个文件
- `/github-release upload v1.0.0 ./dist/*` - 上传目录下所有文件

### 7. 下载 Assets

```
/github-release download <tag> [--pattern <pattern>] [--dir <directory>]
```

**示例：**
- `/github-release download v1.0.0` - 下载所有 assets
- `/github-release download v1.0.0 --pattern "*.exe"` - 下载特定文件
- `/github-release download v1.0.0 --dir ./downloads` - 下载到指定目录

### 8. 删除 Asset

```
/github-release delete-asset <tag> <asset-name>
```

**示例：**
- `/github-release delete-asset v1.0.0 app.exe` - 删除特定 asset

### 9. 验证 Release 认证

```
/github-release verify <tag>
```

**示例：**
- `/github-release verify v1.0.0` - 验证 attestation

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **列出 releases**: `gh release list --json <fields> --limit <n>`
2. **查看 release**: `gh release view <tag> --json <fields>`
3. **创建 release**: `gh release create <tag> --title <title> --notes <notes> --draft --prerelease`
4. **编辑 release**: `gh release edit <tag> --title <title> --notes <notes>`
5. **删除 release**: `gh release delete <tag>`
6. **上传 assets**: `gh release upload <tag> <files>`
7. **下载 assets**: `gh release download <tag> --pattern <pattern> --dir <dir>`
8. **删除 asset**: `gh release delete-asset <tag> <asset-name>`
9. **验证认证**: `gh release verify <tag>`

## 输出格式化

- **列表输出**: Markdown 表格，显示标签、名称、类型、发布时间
- **详情输出**: 显示标签、名称、描述、作者、assets 列表
- **上传输出**: 显示上传进度和结果
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 发布新版本
```
# 创建新版本
/github-release create v1.0.0 \
  --title "Version 1.0.0" \
  --notes "## What's Changed
- Feature 1
- Feature 2
- Bug fixes"

# 上传构建产物
/github-release upload v1.0.0 ./dist/*.zip ./dist/*.tar.gz
```

### 场景 2: 预发布和草稿
```
# 创建草稿版本
/github-release create v2.0.0 --draft --title "Coming Soon"

# 编辑后发布
/github-release edit v2.0.0 --draft false
```

### 场景 3: 管理 Releases
```
# 查看最新版本
/github-release view latest

# 列出所有 releases
/github-release list --limit 20

# 删除错误的 release
/github-release delete v1.0.1
```

### 场景 4: 下载构建产物
```
# 下载特定版本的所有 assets
/github-release download v1.0.0 --dir ./downloads

# 只下载 Windows 版本
/github-release download v1.0.0 --pattern "*win*.exe"
```

### 场景 5: 更新 Release 信息
```
# 修改标题和描述
/github-release edit v1.0.0 \
  --title "Version 1.0.0 (Stable)" \
  --notes "Updated release notes"

# 设为最新版本
/github-release edit v1.0.0 --latest
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)
- `jq` - JSON 处理工具

## 注意事项

1. **Tag 命名**: 推荐使用语义化版本 (SemVer) 如 `v1.0.0`
2. **Draft 版本**: 草稿版本不会通知用户
3. **Prerelease**: 预发布版本用于 alpha/beta/rc 版本
4. **文件大小**: 单个 asset 最大 2GB
5. **自动生成**: 可以使用 `--generate-notes` 自动生成发布说明
6. **Attestation**: 支持验证 artifact 的来源和完整性

## 自动化发布示例

结合 GitHub Actions 自动发布：

```yaml
# .github/workflows/release.yml
on:
  push:
    tags: ['v*']
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: ./build.sh
      - name: Create Release
        run: |
          gh release create ${{ github.ref_name }} \
            --generate-notes \
            ./dist/*
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
