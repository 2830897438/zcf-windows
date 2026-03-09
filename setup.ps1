# ============================================================
# 呆呆鸟 API 配置脚本 - 为 Claude Code 配置 API 和模型 (Windows)
# 站点: https://api.daidaibird.top
# ============================================================

$ErrorActionPreference = "Stop"

$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$SETTINGS_FILE = "$CLAUDE_DIR\settings.json"
$API_BASE_URL = "https://api.daidaibird.top"

$MODELS = @(
    "[官Max]claude-opus-4-6-20260205-thinking"
    "[官Max]claude-opus-4-6-20260205"
    "[官Max]claude-opus-4-5-20251101-thinking"
    "[官Max]claude-opus-4-5-20251101"
    "[官Max]claude-sonnet-4-6-20260217-thinking"
    "[官Max]claude-sonnet-4-6-20260217"
    "[官Max]claude-sonnet-4-5-20250929-thinking"
    "[官Max]claude-sonnet-4-5-20250929"
)

$MODEL_NAMES = @(
    "Opus 4.6 (Thinking)"
    "Opus 4.6"
    "Opus 4.5 (Thinking)"
    "Opus 4.5"
    "Sonnet 4.6 (Thinking)"
    "Sonnet 4.6"
    "Sonnet 4.5 (Thinking)"
    "Sonnet 4.5"
)

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   呆呆鸟 API - Claude Code 配置工具" -ForegroundColor Cyan
Write-Host "   站点: $API_BASE_URL" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ---- 步骤 1: 输入 API Key ----
Write-Host "[步骤 1/2] 请输入你的 API Key" -ForegroundColor Blue
Write-Host "(从呆呆鸟站点获取你的 Key)" -ForegroundColor Yellow
Write-Host ""
$API_KEY = Read-Host "API Key"

if ([string]::IsNullOrWhiteSpace($API_KEY)) {
    Write-Host "错误: API Key 不能为空" -ForegroundColor Red
    exit 1
}

# ---- 步骤 2: 选择模型 ----
Write-Host ""
Write-Host "[步骤 2/2] 请选择要使用的模型" -ForegroundColor Blue
Write-Host ""

for ($i = 0; $i -lt $MODELS.Count; $i++) {
    $num = $i + 1
    Write-Host "  $num) " -ForegroundColor Green -NoNewline
    Write-Host $MODEL_NAMES[$i]
    Write-Host "     $($MODELS[$i])" -ForegroundColor Yellow
}

Write-Host ""
$MODEL_CHOICE = Read-Host "请输入序号 (1-$($MODELS.Count))"

# 验证输入
$choice = 0
if (-not [int]::TryParse($MODEL_CHOICE, [ref]$choice) -or $choice -lt 1 -or $choice -gt $MODELS.Count) {
    Write-Host "错误: 请输入 1-$($MODELS.Count) 之间的数字" -ForegroundColor Red
    exit 1
}

$SELECTED_MODEL = $MODELS[$choice - 1]
$SELECTED_NAME = $MODEL_NAMES[$choice - 1]

# ---- 写入配置 ----
Write-Host ""
Write-Host "正在配置..." -ForegroundColor Blue

# 确保 ~/.claude 目录存在
if (-not (Test-Path $CLAUDE_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_DIR -Force | Out-Null
}

# 如果已有 settings.json，先备份
if (Test-Path $SETTINGS_FILE) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $BACKUP_FILE = "$SETTINGS_FILE.backup.$timestamp"
    Copy-Item $SETTINGS_FILE $BACKUP_FILE
    Write-Host "已备份现有配置到: $BACKUP_FILE" -ForegroundColor Yellow
}

# 读取现有配置或创建新的
$settings = @{}
if (Test-Path $SETTINGS_FILE) {
    try {
        $content = Get-Content $SETTINGS_FILE -Raw -Encoding UTF8
        $settings = $content | ConvertFrom-Json -AsHashtable
    } catch {
        $settings = @{}
    }
}

# 确保 env 对象存在
if (-not $settings.ContainsKey("env")) {
    $settings["env"] = @{}
}

# 设置 API 配置
$settings["env"]["ANTHROPIC_BASE_URL"] = $API_BASE_URL
$settings["env"]["ANTHROPIC_AUTH_TOKEN"] = $API_KEY
$settings["env"]["ANTHROPIC_MODEL"] = $SELECTED_MODEL

# 移除可能冲突的配置
$settings["env"].Remove("ANTHROPIC_API_KEY")
$settings.Remove("model")

# 写入配置文件
$json = $settings | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($SETTINGS_FILE, $json, [System.Text.UTF8Encoding]::new($false))

# ---- 完成 ----
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   配置完成!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "  API 地址:  " -ForegroundColor Cyan -NoNewline
Write-Host $API_BASE_URL
Write-Host "  模型:      " -ForegroundColor Cyan -NoNewline
Write-Host $SELECTED_NAME
Write-Host "  模型 ID:   " -ForegroundColor Cyan -NoNewline
Write-Host $SELECTED_MODEL
Write-Host "  配置文件:  " -ForegroundColor Cyan -NoNewline
Write-Host $SETTINGS_FILE
Write-Host ""
Write-Host "现在可以启动 Claude Code 使用了!" -ForegroundColor Green
Write-Host ""
