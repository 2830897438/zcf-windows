# ============================================================
# 呆呆鸟 API 配置脚本 - 为 Claude Code 配置 API 和模型 (Windows)
# 站点: https://api.daidaibird.top
# ============================================================

$ErrorActionPreference = "Stop"

$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$SETTINGS_FILE = "$CLAUDE_DIR\settings.json"
$API_BASE_URL = "https://api.daidaibird.top"

# 模型表: 分组 / 模型 ID / 显示名
$MODEL_TABLE = @(
    # ---------- 官Max (Claude Max 订阅反代) ----------
    @{ Group="官Max";    Id="[官Max]claude-opus-4-7";                        Name="Opus 4.7" }
    @{ Group="官Max";    Id="[官Max]claude-opus-4-6-20260205-thinking";      Name="Opus 4.6 Thinking" }
    @{ Group="官Max";    Id="[官Max]claude-opus-4-6-20260205";               Name="Opus 4.6" }
    @{ Group="官Max";    Id="[官Max]claude-opus-4-5-20251101-thinking";      Name="Opus 4.5 Thinking" }
    @{ Group="官Max";    Id="[官Max]claude-opus-4-5-20251101";               Name="Opus 4.5" }
    @{ Group="官Max";    Id="[官Max]claude-sonnet-4-6-20260217-thinking";    Name="Sonnet 4.6 Thinking" }
    @{ Group="官Max";    Id="[官Max]claude-sonnet-4-6-20260217";             Name="Sonnet 4.6" }
    @{ Group="官Max";    Id="[官Max]claude-sonnet-4-5-20250929-thinking";    Name="Sonnet 4.5 Thinking" }
    @{ Group="官Max";    Id="[官Max]claude-sonnet-4-5-20250929";             Name="Sonnet 4.5" }

    # ---------- 官AWS (AWS Bedrock 官方) ----------
    @{ Group="官AWS";    Id="[官AWS]claude-opus-4-6-20260205-thinking";      Name="Opus 4.6 Thinking" }
    @{ Group="官AWS";    Id="[官AWS]claude-opus-4-6-20260205";               Name="Opus 4.6" }
    @{ Group="官AWS";    Id="[官AWS]claude-opus-4-5-20251101-thinking";      Name="Opus 4.5 Thinking" }
    @{ Group="官AWS";    Id="[官AWS]claude-opus-4-5-20251101";               Name="Opus 4.5" }
    @{ Group="官AWS";    Id="[官AWS]claude-sonnet-4-6-20260217-thinking";    Name="Sonnet 4.6 Thinking" }
    @{ Group="官AWS";    Id="[官AWS]claude-sonnet-4-6-20260217";             Name="Sonnet 4.6" }
    @{ Group="官AWS";    Id="[官AWS]claude-sonnet-4-5-20250929-thinking";    Name="Sonnet 4.5 Thinking" }
    @{ Group="官AWS";    Id="[官AWS]claude-sonnet-4-5-20250929";             Name="Sonnet 4.5" }

    # ---------- 官cookie (Cookie 反代) ----------
    @{ Group="官cookie"; Id="[官cookie]claude-opus-4-7";                     Name="Opus 4.7" }
    @{ Group="官cookie"; Id="[官cookie]claude-opus-4-6-20260205-thinking";   Name="Opus 4.6 Thinking" }
    @{ Group="官cookie"; Id="[官cookie]claude-opus-4-6-20260205";            Name="Opus 4.6" }
    @{ Group="官cookie"; Id="[官cookie]claude-opus-4-5-20251101-thinking";   Name="Opus 4.5 Thinking" }
    @{ Group="官cookie"; Id="[官cookie]claude-opus-4-5-20251101";            Name="Opus 4.5" }
    @{ Group="官cookie"; Id="[官cookie]claude-sonnet-4-6-20260217-thinking"; Name="Sonnet 4.6 Thinking" }
    @{ Group="官cookie"; Id="[官cookie]claude-sonnet-4-6-20260217";          Name="Sonnet 4.6" }
    @{ Group="官cookie"; Id="[官cookie]claude-sonnet-4-5-20250929-thinking"; Name="Sonnet 4.5 Thinking" }
    @{ Group="官cookie"; Id="[官cookie]claude-sonnet-4-5-20250929";          Name="Sonnet 4.5" }

    # ---------- code (Claude Code 专用通道) ----------
    @{ Group="code";     Id="[code]claude-opus-4-7";                         Name="Opus 4.7" }
    @{ Group="code";     Id="[code]claude-opus-4-6-20260205-thinking";       Name="Opus 4.6 Thinking" }
    @{ Group="code";     Id="[code]claude-opus-4-6-20260205";                Name="Opus 4.6" }
    @{ Group="code";     Id="[code]claude-opus-4-1-20250805-thinking";       Name="Opus 4.1 Thinking" }
    @{ Group="code";     Id="[code]claude-opus-4-1-20250805";                Name="Opus 4.1" }
    @{ Group="code";     Id="[code]claude-opus-4-20250514-thinking";         Name="Opus 4 Thinking" }
    @{ Group="code";     Id="[code]claude-opus-4-20250514";                  Name="Opus 4" }
    @{ Group="code";     Id="[code]claude-sonnet-4-6-20260217-thinking";     Name="Sonnet 4.6 Thinking" }
    @{ Group="code";     Id="[code]claude-sonnet-4-6-20260217";              Name="Sonnet 4.6" }

    # ---------- 啾啾(稳) ----------
    @{ Group="啾啾(稳)"; Id="[啾啾(稳)]claude-opus-4-7";                     Name="Opus 4.7" }
    @{ Group="啾啾(稳)"; Id="[啾啾(稳)]claude-opus-4-6-20260205-thinking";   Name="Opus 4.6 Thinking" }
    @{ Group="啾啾(稳)"; Id="[啾啾(稳)]claude-opus-4-6-20260205";            Name="Opus 4.6" }
    @{ Group="啾啾(稳)"; Id="[啾啾(稳)]claude-sonnet-4-6-20260217-thinking"; Name="Sonnet 4.6 Thinking" }
    @{ Group="啾啾(稳)"; Id="[啾啾(稳)]claude-sonnet-4-6-20260217";          Name="Sonnet 4.6" }

    # ---------- 啾啾 ----------
    @{ Group="啾啾";     Id="[啾啾]claude-opus-4-6-20260205-thinking";       Name="Opus 4.6 Thinking" }
    @{ Group="啾啾";     Id="[啾啾]claude-opus-4-6-20260205";                Name="Opus 4.6" }
    @{ Group="啾啾";     Id="[啾啾]claude-opus-4-5-20251101-thinking";       Name="Opus 4.5 Thinking" }
    @{ Group="啾啾";     Id="[啾啾]claude-opus-4-5-20251101";                Name="Opus 4.5" }
    @{ Group="啾啾";     Id="[啾啾]claude-sonnet-4-6-20260217-thinking";     Name="Sonnet 4.6 Thinking" }
    @{ Group="啾啾";     Id="[啾啾]claude-sonnet-4-6-20260217";              Name="Sonnet 4.6" }
    @{ Group="啾啾";     Id="[啾啾]claude-sonnet-4-5-20250929-thinking";     Name="Sonnet 4.5 Thinking" }
    @{ Group="啾啾";     Id="[啾啾]claude-sonnet-4-5-20250929";              Name="Sonnet 4.5" }

    # ---------- 嘎嘎 ----------
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-6-20260205-thinking";       Name="Opus 4.6 Thinking" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-6-20260205";                Name="Opus 4.6" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-1-20250805-thinking";       Name="Opus 4.1 Thinking" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-1-20250805";                Name="Opus 4.1" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-20250514-thinking";         Name="Opus 4 Thinking" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-opus-4-20250514";                  Name="Opus 4" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-sonnet-4-6-20260217-thinking";     Name="Sonnet 4.6 Thinking" }
    @{ Group="嘎嘎";     Id="[嘎嘎]claude-sonnet-4-6-20260217";              Name="Sonnet 4.6" }

    # ---------- 默认 (无前缀,兜底渠道) ----------
    @{ Group="默认";     Id="claude-opus-4-5-20251101-thinking";             Name="Opus 4.5 Thinking" }
    @{ Group="默认";     Id="claude-opus-4-5-20251101";                      Name="Opus 4.5" }
    @{ Group="默认";     Id="claude-opus-4-1-20250805-thinking";             Name="Opus 4.1 Thinking" }
    @{ Group="默认";     Id="claude-opus-4-1-20250805";                      Name="Opus 4.1" }
    @{ Group="默认";     Id="claude-opus-4-20250514-thinking";               Name="Opus 4 Thinking" }
    @{ Group="默认";     Id="claude-opus-4-20250514";                        Name="Opus 4" }
    @{ Group="默认";     Id="claude-sonnet-4-5-20250929-thinking";           Name="Sonnet 4.5 Thinking" }
    @{ Group="默认";     Id="claude-sonnet-4-5-20250929";                    Name="Sonnet 4.5" }
    @{ Group="默认";     Id="claude-sonnet-4-20250514-thinking";             Name="Sonnet 4 Thinking" }
    @{ Group="默认";     Id="claude-sonnet-4-20250514";                      Name="Sonnet 4" }
    @{ Group="默认";     Id="claude-3-7-sonnet-20250219-thinking";           Name="Sonnet 3.7 Thinking" }
    @{ Group="默认";     Id="claude-3-7-sonnet-20250219";                    Name="Sonnet 3.7" }
    @{ Group="默认";     Id="claude-haiku-4-5-20251001-thinking";            Name="Haiku 4.5 Thinking" }
    @{ Group="默认";     Id="claude-haiku-4-5-20251001";                     Name="Haiku 4.5" }
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
Write-Host "[步骤 2/2] 请选择要使用的模型 (共 $($MODEL_TABLE.Count) 个)" -ForegroundColor Blue

$lastGroup = ""
for ($i = 0; $i -lt $MODEL_TABLE.Count; $i++) {
    $item = $MODEL_TABLE[$i]
    if ($item.Group -ne $lastGroup) {
        Write-Host ""
        Write-Host "  === $($item.Group) ===" -ForegroundColor Magenta
        $lastGroup = $item.Group
    }
    $num = $i + 1
    Write-Host ("  {0,3}) " -f $num) -ForegroundColor Green -NoNewline
    Write-Host ("{0,-22}" -f $item.Name) -NoNewline
    Write-Host "  $($item.Id)" -ForegroundColor DarkGray
}

Write-Host ""
$MODEL_CHOICE = Read-Host "请输入序号 (1-$($MODEL_TABLE.Count))"

# 验证输入
$choice = 0
if (-not [int]::TryParse($MODEL_CHOICE, [ref]$choice) -or $choice -lt 1 -or $choice -gt $MODEL_TABLE.Count) {
    Write-Host "错误: 请输入 1-$($MODEL_TABLE.Count) 之间的数字" -ForegroundColor Red
    exit 1
}

$SELECTED = $MODEL_TABLE[$choice - 1]
$SELECTED_MODEL = $SELECTED.Id
$SELECTED_NAME = "[$($SELECTED.Group)] $($SELECTED.Name)"

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
