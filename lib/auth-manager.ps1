# GitHub CLI 认证管理脚本 (PowerShell 版本)
# 用于加载和管理 GitHub Token 环境变量

param(
    [Parameter(Position=0)]
    [ValidateSet('load', 'verify', 'setup', 'help')]
    [string]$Action = 'help'
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EnvFile = Join-Path $ScriptDir '..\.env' | Resolve-Path -ErrorAction SilentlyContinue
if (-not $EnvFile) {
    $EnvFile = Join-Path $ScriptDir '..\.env'
}

# 加载环境变量
function Load-Env {
    if (-not (Test-Path $EnvFile)) {
        Write-Host "错误：找不到 .env 文件：$EnvFile" -ForegroundColor Red
        Write-Host "请复制 .env.example 并配置你的 GitHub Token"
        return $false
    }

    # 读取 GH_TOKEN
    $content = Get-Content $EnvFile -Raw
    $token = $content | Select-String '^GH_TOKEN=(.+)$' | ForEach-Object { $_.Matches.Groups[1].Value }

    if ([string]::IsNullOrEmpty($token) -or $token -eq 'your_github_token_here') {
        Write-Host "错误：请先配置有效的 GH_TOKEN" -ForegroundColor Red
        Write-Host "编辑文件：$EnvFile"
        return $false
    }

    # 设置环境变量（当前进程）
    [Environment]::SetEnvironmentVariable('GH_TOKEN', $token, 'Process')
    $env:GH_TOKEN = $token

    Write-Host '✓ GitHub Token 已加载' -ForegroundColor Green
    return $true
}

# 验证认证状态
function Verify-Auth {
    if ([string]::IsNullOrEmpty($env:GH_TOKEN)) {
        $loaded = Load-Env
        if (-not $loaded) {
            return $false
        }
    }

    # 检查 gh 是否可用
    $ghPath = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $ghPath) {
        # 尝试从默认路径加载
        $ghExe = 'C:\Program Files\GitHub CLI\gh.exe'
        if (Test-Path $ghExe) {
            $env:Path = "$env:Path;$ghExe\.."
        }
    }

    try {
        & gh auth status 2>&1
        return $?
    } catch {
        Write-Host "验证失败：$_" -ForegroundColor Red
        return $false
    }
}

# 交互式配置
function Setup-GitHubAuth {
    Write-Host '=== GitHub CLI 认证配置 ===' -ForegroundColor Cyan
    Write-Host ''

    if (Test-Path $EnvFile) {
        Write-Host "发现现有配置：$EnvFile"
        $confirm = Read-Host '是否覆盖现有配置？(y/N)'
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Host '已取消'
            return
        }
    }

    Write-Host ''
    Write-Host '请输入你的 GitHub Token:'
    Write-Host '获取方式：https://github.com/settings/tokens'
    Write-Host '需要的 scopes: repo, workflow, read:org, gist'
    Write-Host ''

    $token = Read-Host 'Token' -AsSecureString
    $plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
    )

    if ([string]::IsNullOrEmpty($plainToken)) {
        Write-Host '错误：Token 不能为空' -ForegroundColor Red
        return
    }

    # 写入 .env 文件
    $envContent = @"
# GitHub CLI 认证配置
GH_TOKEN=$plainToken
"@

    Set-Content -Path $EnvFile -Value $envContent -Encoding UTF8

    Write-Host "✓ 配置已保存到：$EnvFile" -ForegroundColor Green

    # 清除内存中的明文 token
    $plainToken = $null

    # 加载环境变量
    Load-Env
}

# 显示帮助
function Show-Help {
    Write-Host '用法：.\auth-manager.ps1 [action]' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '动作:' -ForegroundColor Yellow
    Write-Host '  load   - 加载环境变量'
    Write-Host '  verify - 验证认证状态'
    Write-Host '  setup  - 交互式配置'
    Write-Host '  help   - 显示此帮助信息 (默认)'
    Write-Host ''
    Write-Host '示例:' -ForegroundColor Yellow
    Write-Host '  .\auth-manager.ps1 load'
    Write-Host '  .\auth-manager.ps1 verify'
    Write-Host '  .\auth-manager.ps1 setup'
    Write-Host ''
}

# 主逻辑
switch ($Action.ToLower()) {
    'load'   { Load-Env }
    'verify' { Verify-Auth }
    'setup'  { Setup-GitHubAuth }
    default  { Show-Help }
}
