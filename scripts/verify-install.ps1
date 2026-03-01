# GitHub CLI Skills 环境验证脚本 (PowerShell 版本)
# 用于检查所有必需的依赖是否已安装

$ErrorActionPreference = 'Continue'

# 颜色定义
$Green = 'Green'
$Red = 'Red'
$Yellow = 'Yellow'

# 检查结果计数
$script:Passed = 0
$script:Failed = 0
$script:Warnings = 0

# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Join-Path $ScriptDir '..'

# 添加 gh 到 PATH
$ghPath = 'C:\Program Files\GitHub CLI'
if (Test-Path $ghPath) {
    $env:Path = "$env:Path;$ghPath"
}

# 检查函数
function Check-Gh {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        $version = & gh --version 2>&1 | Select-Object -First 1
        Write-Host "✓ gh CLI: $version" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ gh CLI: 未安装" -ForegroundColor $Red
        Write-Host "  安装命令：winget install GitHub.cli"
        Write-Host "  或访问：https://github.com/cli/cli#installation"
        $script:Failed++
    }
}

function Check-Jq {
    $jq = Get-Command jq -ErrorAction SilentlyContinue
    if ($jq) {
        $version = & jq --version 2>&1
        Write-Host "✓ jq: $version" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ jq: 未安装" -ForegroundColor $Red
        Write-Host "  安装命令：winget install jqlang.jq"
        $script:Failed++
    }
}

function Check-Git {
    $git = Get-Command git -ErrorAction SilentlyContinue
    if ($git) {
        $version = & git --version 2>&1
        Write-Host "✓ git: $version" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ git: 未安装" -ForegroundColor $Red
        Write-Host "  安装命令：winget install Git.Git"
        $script:Failed++
    }
}

function Check-EnvFile {
    $envFile = Join-Path $BaseDir '.env'

    if (-not (Test-Path $envFile)) {
        Write-Host "! .env 文件：不存在" -ForegroundColor $Yellow
        Write-Host "  请复制 .env.example 并配置 GitHub Token"
        $script:Warnings++
        return
    }

    # 检查 Token 是否配置
    $content = Get-Content $envFile -Raw
    $token = $content | Select-String '^GH_TOKEN=(.+)$' | ForEach-Object { $_.Matches.Groups[1].Value }

    if ([string]::IsNullOrEmpty($token) -or $token -eq 'your_github_token_here') {
        Write-Host "! .env 文件：Token 未配置" -ForegroundColor $Yellow
        Write-Host "  请编辑 $envFile 并填入有效的 GitHub Token"
        $script:Warnings++
    } else {
        Write-Host "✓ .env 文件：已配置" -ForegroundColor $Green
        $script:Passed++

        # 验证 Token
        $env:GH_TOKEN = $token
        try {
            $authStatus = & gh auth status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ GitHub 认证：有效" -ForegroundColor $Green
                $script:Passed++
            } else {
                Write-Host "! GitHub 认证：无法验证 (可能是网络问题)" -ForegroundColor $Yellow
                $script:Warnings++
            }
        } catch {
            Write-Host "! GitHub 认证：无法验证" -ForegroundColor $Yellow
            $script:Warnings++
        }
    }
}

function Check-Scripts {
    $libDir = Join-Path $BaseDir 'lib'

    # 检查 PowerShell 版本
    if (Test-Path (Join-Path $libDir 'auth-manager.ps1')) {
        Write-Host "✓ auth-manager.ps1: 存在" -ForegroundColor $Green
        $script:Passed++
    } elseif (Test-Path (Join-Path $libDir 'auth-manager.sh')) {
        Write-Host "! auth-manager.sh: 存在 (建议升级为 .ps1 版本)" -ForegroundColor $Yellow
        $script:Passed++
    } else {
        Write-Host "✗ auth-manager: 不存在" -ForegroundColor $Red
        $script:Failed++
    }

    if (Test-Path (Join-Path $libDir 'output-formatter.ps1')) {
        Write-Host "✓ output-formatter.ps1: 存在" -ForegroundColor $Green
        $script:Passed++
    } elseif (Test-Path (Join-Path $libDir 'output-formatter.sh')) {
        Write-Host "! output-formatter.sh: 存在 (建议升级为 .ps1 版本)" -ForegroundColor $Yellow
        $script:Passed++
    } else {
        Write-Host "✗ output-formatter: 不存在" -ForegroundColor $Red
        $script:Failed++
    }
}

function Check-Skills {
    $commandsDir = Join-Path $BaseDir 'commands'

    # 检查 github-repo.md
    if (Test-Path (Join-Path $commandsDir 'github-repo.md')) {
        Write-Host "✓ github-repo.md: 存在" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ github-repo.md: 不存在" -ForegroundColor $Red
        $script:Failed++
    }

    # 检查 github-pr.md
    if (Test-Path (Join-Path $commandsDir 'github-pr.md')) {
        Write-Host "✓ github-pr.md: 存在" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ github-pr.md: 不存在" -ForegroundColor $Red
        $script:Failed++
    }

    # 检查 github-issue.md
    if (Test-Path (Join-Path $commandsDir 'github-issue.md')) {
        Write-Host "✓ github-issue.md: 存在" -ForegroundColor $Green
        $script:Passed++
    } else {
        Write-Host "✗ github-issue.md: 不存在" -ForegroundColor $Red
        $script:Failed++
    }
}

# 主逻辑
Write-Host '=== GitHub CLI Skills 环境检查 ===' -ForegroundColor Cyan
Write-Host ''

Write-Host '━━━ 依赖检查 ━━━'
Check-Gh
Check-Jq
Check-Git

Write-Host ''
Write-Host '━━━ 配置检查 ━━━'
Check-EnvFile

Write-Host ''
Write-Host '━━━ 脚本检查 ━━━'
Check-Scripts

Write-Host ''
Write-Host '━━━ 技能检查 ━━━'
Check-Skills

Write-Host ''
Write-Host '━━━ 检查完成 ━━━'
Write-Host ''
Write-Host "结果：$($script:Passed) 通过，$($script:Warnings) 警告，$($script:Failed) 失败"

if ($script:Failed -gt 0) {
    Write-Host ''
    Write-Host '请修复上述错误后重试' -ForegroundColor Red
    exit 1
} elseif ($script:Warnings -gt 0) {
    Write-Host ''
    Write-Host '部分配置需要完善，但基本功能可用' -ForegroundColor Yellow
    exit 0
} else {
    Write-Host ''
    Write-Host '所有检查通过！' -ForegroundColor Green
    exit 0
}
