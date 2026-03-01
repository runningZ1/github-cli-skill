---
name: github-attestation
description: 通过自然语言验证 GitHub Artifact 认证（下载、验证）
version: 1.0.0
argument-hint: [operation] [options]
allowed-tools: Bash(*)
---

# GitHub Artifact Attestation 管理技能

## 认证配置

GitHub Token 通过环境变量 `GH_TOKEN` 提供。

**配置步骤：**
1. 复制 `~/.claude/skills/github-cli/.env.example` 为 `.env`
2. 在 `.env` 文件中填入你的 GitHub Token

**所需权限：**
- `repo` - 访问私有仓库

## 支持的操作

### 1. 下载认证

```
/github-attestation download <artifact> [--owner <owner>]
```

**示例：**
- `/github-attestation download app.exe` - 下载 artifact 的认证
- `/github-attestation download app.exe --owner cli` - 下载指定组织的认证

### 2. 验证认证

```
/github-attestation verify <artifact> [--owner <owner>]
```

**示例：**
- `/github-attestation verify app.exe` - 验证 artifact 认证
- `/github-attestation verify app.exe --owner cli` - 验证指定组织的认证

### 3. 查看可信根

```
/github-attestation trusted-root
```

**示例：**
- `/github-attestation trusted-root` - 输出可信根 JSON

## 命令构建逻辑

根据用户输入自然语言，识别操作类型并构建对应的 gh 命令：

1. **下载认证**: `gh attestation download <artifact>`
2. **验证认证**: `gh attestation verify <artifact>`
3. **可信根**: `gh attestation trusted-root`

## 输出格式化

- **验证结果**: 显示验证状态、签名者、时间
- **错误信息**: 清晰标注错误原因和解决建议

## 环境变量设置

```powershell
# 加载认证信息
. ~/.claude/skills/github-cli/lib/auth-manager.ps1 load

# 验证认证
gh auth status
```

## 使用场景

### 场景 1: 验证下载的文件
```
# 验证 artifact 认证
/github-attestation verify app.exe
```

### 场景 2: 下载认证用于离线验证
```
# 下载认证
/github-attestation download app.exe
```

## 依赖工具

- `gh` - GitHub CLI (v2.0+)

## 注意事项

1. **认证来源**: 来自 GitHub Actions 构建
2. **离线验证**: 可以下载认证进行离线验证
3. **信任链**: 基于 Sigstore 信任链
