# GitHub CLI 输出格式化脚本 (PowerShell 版本)
# 将 gh CLI 的 JSON 输出格式化为易读的 Markdown 格式

param(
    [Parameter(Position=0)]
    [ValidateSet('repo-list', 'repo-view', 'pr-list', 'issue-list', 'repo-create', 'error', 'strip', 'default')]
    [string]$Format = 'default'
)

# 从管道读取输入
$InputData = $input | Out-String

# 格式化函数
function Format-RepoList {
    param([string]$JsonInput)

    if ([string]::IsNullOrEmpty($JsonInput)) {
        Write-Host "没有数据"
        return
    }

    Write-Host "| 仓库 | 可见性 | 描述 |"
    Write-Host "|------|--------|------|"

    try {
        $json = $JsonInput | ConvertFrom-Json
        foreach ($repo in $json) {
            $desc = if ($repo.description) { $repo.description } else { "无" }
            # 处理描述中的换行和管道符
            $desc = $desc -replace '\|', '¦' -replace '\n', ' '
            Write-Host "| $($repo.name) | $($repo.visibility) | $desc |"
        }
    } catch {
        Write-Host "JSON 解析失败：$_"
        Write-Host "原始输入：$JsonInput"
    }
}

function Format-RepoView {
    param([string]$JsonInput)

    if ([string]::IsNullOrEmpty($JsonInput)) {
        Write-Host "没有数据"
        return
    }

    try {
        $json = $JsonInput | ConvertFrom-Json

        $name = if ($json.fullName) { $json.fullName } else { $json.name }
        $description = if ($json.description) { $json.description } else { "无描述" }
        $visibility = $json.visibility
        $url = $json.url
        $stars = if ($json.stargazerCount) { $json.stargazerCount } else { 0 }
        $forks = if ($json.forkCount) { $json.forkCount } else { 0 }
        $issues = if ($json.issues) { $json.issues.totalCount } else { 0 }
        $prs = if ($json.pullRequests) { $json.pullRequests.totalCount } else { 0 }
        $updatedAt = if ($json.updatedAt) { $json.updatedAt } elseif ($json.pushedAt) { $json.pushedAt } else { "未知" }

        Write-Host ""
        Write-Host "## $name"
        Write-Host ""
        Write-Host "**描述**: $description"
        Write-Host ""
        Write-Host "| 属性 | 值 |"
        Write-Host "|------|-----|"
        Write-Host "| 可见性 | $visibility |"
        Write-Host "| Stars | $stars |"
        Write-Host "| Forks | $forks |"
        Write-Host "| Issues | $issues |"
        Write-Host "| Pull Requests | $prs |"
        Write-Host "| 更新时间 | $updatedAt |"
        Write-Host ""
        Write-Host "**URL**: $url"
    } catch {
        Write-Host "JSON 解析失败：$_"
    }
}

function Format-PrIssueList {
    param(
        [string]$JsonInput,
        [string]$Type = 'pr'
    )

    if ([string]::IsNullOrEmpty($JsonInput)) {
        Write-Host "没有数据"
        return
    }

    try {
        $json = $JsonInput | ConvertFrom-Json

        if ($Type -eq 'pr') {
            Write-Host "| # | 标题 | 状态 | 作者 | 更新时间 |"
            Write-Host "|---|------|------|------|----------|"
            foreach ($item in $json) {
                $title = $item.title
                if ($title.Length -gt 40) {
                    $title = $title.Substring(0, 40) + "..."
                }
                $updateTime = if ($item.updatedAt) { $item.updatedAt.Substring(0, 10) } else { "未知" }
                $author = if ($item.author) { $item.author.login } else { "未知" }
                Write-Host "| #$($item.number) | $title | $($item.state) | $author | $updateTime |"
            }
        } else {
            Write-Host "| # | 标题 | 状态 | 标签 |"
            Write-Host "|---|------|------|------|"
            foreach ($item in $json) {
                $title = $item.title
                if ($title.Length -gt 50) {
                    $title = $title.Substring(0, 50) + "..."
                }
                $labels = if ($item.labels -and $item.labels.Count -gt 0) {
                    ($item.labels.name -join ', ')
                } else {
                    "无"
                }
                Write-Host "| #$($item.number) | $title | $($item.state) | $labels |"
            }
        }
    } catch {
        Write-Host "JSON 解析失败：$_"
    }
}

function Format-RepoCreateResult {
    param([string]$Output)

    Write-Host ""
    Write-Host "### 仓库创建成功"
    Write-Host ""
    Write-Host $Output
    Write-Host ""
    Write-Host "**下一步操作**:"
    Write-Host "```bash"
    Write-Host "# 克隆仓库到本地"
    Write-Host "gh repo clone <owner>/<repo>"
    Write-Host ""
    Write-Host "# 或初始化现有目录"
    Write-Host "git init"
    Write-Host "git remote add origin git@github.com:<owner>/<repo>.git"
    Write-Host "```"
}

function Format-Error {
    param([string]$ErrorMsg)

    Write-Host ""
    Write-Host "### 错误"
    Write-Host ""
    Write-Host "```"
    Write-Host $ErrorMsg
    Write-Host "```"
    Write-Host ""
    Write-Host "**可能的原因**:"
    Write-Host "- GitHub Token 无效或过期"
    Write-Host "- 权限不足"
    Write-Host "- 网络问题"
    Write-Host ""
    Write-Host "**建议**:"
    Write-Host "1. 运行 `gh auth status` 检查认证状态"
    Write-Host "2. 确认 Token 配置正确"
    Write-Host "3. 重试命令"
}

function Strip-Ansi {
    param([string]$Text)
    # PowerShell 通常不会输出 ANSI 码，此函数用于兼容
    return $Text -replace '\x1b\[[0-9;]*m', ''
}

# 主逻辑
switch ($Format) {
    'repo-list'   { Format-RepoList -JsonInput $InputData }
    'repo-view'   { Format-RepoView -JsonInput $InputData }
    'pr-list'     { Format-PrIssueList -JsonInput $InputData -Type 'pr' }
    'issue-list'  { Format-PrIssueList -JsonInput $InputData -Type 'issue' }
    'repo-create' { Format-RepoCreateResult -Output $InputData }
    'error'       { Format-Error -ErrorMsg $InputData }
    'strip'       { Strip-Ansi -Text $InputData }
    default       { Write-Host $InputData }
}
