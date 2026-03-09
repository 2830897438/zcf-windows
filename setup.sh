#!/usr/bin/env bash
# ============================================================
# 呆呆鸟 API 配置脚本 - 为 Claude Code 配置 API 和模型
# 站点: https://api.daidaibird.top
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
API_BASE_URL="https://api.daidaibird.top"

# 可选模型列表
MODELS=(
  "[官Max]claude-opus-4-6-20260205-thinking"
  "[官Max]claude-opus-4-6-20260205"
  "[官Max]claude-opus-4-5-20251101-thinking"
  "[官Max]claude-opus-4-5-20251101"
  "[官Max]claude-sonnet-4-6-20260217-thinking"
  "[官Max]claude-sonnet-4-6-20260217"
  "[官Max]claude-sonnet-4-5-20250929-thinking"
  "[官Max]claude-sonnet-4-5-20250929"
)

# 模型简称（用于显示）
MODEL_NAMES=(
  "Opus 4.6 (Thinking)"
  "Opus 4.6"
  "Opus 4.5 (Thinking)"
  "Opus 4.5"
  "Sonnet 4.6 (Thinking)"
  "Sonnet 4.6"
  "Sonnet 4.5 (Thinking)"
  "Sonnet 4.5"
)

echo ""
echo -e "${CYAN}${BOLD}============================================${NC}"
echo -e "${CYAN}${BOLD}   呆呆鸟 API - Claude Code 配置工具${NC}"
echo -e "${CYAN}${BOLD}   站点: ${API_BASE_URL}${NC}"
echo -e "${CYAN}${BOLD}============================================${NC}"
echo ""

# ---- 步骤 1: 输入 API Key ----
echo -e "${BLUE}${BOLD}[步骤 1/2] 请输入你的 API Key${NC}"
echo -e "${YELLOW}(从呆呆鸟站点获取你的 Key)${NC}"
echo ""
read -rp "API Key: " API_KEY < /dev/tty

if [ -z "$API_KEY" ]; then
  echo -e "${RED}错误: API Key 不能为空${NC}"
  exit 1
fi

# ---- 步骤 2: 选择模型 ----
echo ""
echo -e "${BLUE}${BOLD}[步骤 2/2] 请选择要使用的模型${NC}"
echo ""

for i in "${!MODELS[@]}"; do
  num=$((i + 1))
  echo -e "  ${GREEN}${num})${NC} ${MODEL_NAMES[$i]}"
  echo -e "     ${YELLOW}${MODELS[$i]}${NC}"
done

echo ""
read -rp "请输入序号 (1-${#MODELS[@]}): " MODEL_CHOICE < /dev/tty

# 验证输入
if ! [[ "$MODEL_CHOICE" =~ ^[0-9]+$ ]] || [ "$MODEL_CHOICE" -lt 1 ] || [ "$MODEL_CHOICE" -gt ${#MODELS[@]} ]; then
  echo -e "${RED}错误: 请输入 1-${#MODELS[@]} 之间的数字${NC}"
  exit 1
fi

SELECTED_MODEL="${MODELS[$((MODEL_CHOICE - 1))]}"
SELECTED_NAME="${MODEL_NAMES[$((MODEL_CHOICE - 1))]}"

# ---- 写入配置 ----
echo ""
echo -e "${BLUE}正在配置...${NC}"

# 确保 ~/.claude 目录存在
mkdir -p "$CLAUDE_DIR"

# 如果已有 settings.json，先备份
if [ -f "$SETTINGS_FILE" ]; then
  BACKUP_FILE="${SETTINGS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$SETTINGS_FILE" "$BACKUP_FILE"
  echo -e "${YELLOW}已备份现有配置到: ${BACKUP_FILE}${NC}"
fi

# 读取现有配置或创建新的
if [ -f "$SETTINGS_FILE" ] && command -v python3 &>/dev/null; then
  # 使用 python3 智能合并配置
  python3 -c "
import json, sys

settings_file = '$SETTINGS_FILE'
try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)
except:
    settings = {}

if 'env' not in settings:
    settings['env'] = {}

# 设置 API 配置
settings['env']['ANTHROPIC_BASE_URL'] = '$API_BASE_URL'
settings['env']['ANTHROPIC_AUTH_TOKEN'] = '$API_KEY'
settings['env']['ANTHROPIC_MODEL'] = '$SELECTED_MODEL'

# 移除可能冲突的配置
settings['env'].pop('ANTHROPIC_API_KEY', None)
settings.pop('model', None)

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
"
elif [ -f "$SETTINGS_FILE" ] && command -v node &>/dev/null; then
  # 使用 node 智能合并配置
  node -e "
const fs = require('fs');
let settings = {};
try { settings = JSON.parse(fs.readFileSync('$SETTINGS_FILE', 'utf8')); } catch {}
if (!settings.env) settings.env = {};
settings.env.ANTHROPIC_BASE_URL = '$API_BASE_URL';
settings.env.ANTHROPIC_AUTH_TOKEN = '$API_KEY';
settings.env.ANTHROPIC_MODEL = '$SELECTED_MODEL';
delete settings.env.ANTHROPIC_API_KEY;
delete settings.model;
fs.writeFileSync('$SETTINGS_FILE', JSON.stringify(settings, null, 2));
"
else
  # 直接写入新配置
  cat > "$SETTINGS_FILE" << JSONEOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$API_BASE_URL",
    "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
    "ANTHROPIC_MODEL": "$SELECTED_MODEL"
  }
}
JSONEOF
fi

# ---- 完成 ----
echo ""
echo -e "${GREEN}${BOLD}============================================${NC}"
echo -e "${GREEN}${BOLD}   配置完成!${NC}"
echo -e "${GREEN}${BOLD}============================================${NC}"
echo ""
echo -e "  ${CYAN}API 地址:${NC}  $API_BASE_URL"
echo -e "  ${CYAN}模型:${NC}      $SELECTED_NAME"
echo -e "  ${CYAN}模型 ID:${NC}   $SELECTED_MODEL"
echo -e "  ${CYAN}配置文件:${NC}  $SETTINGS_FILE"
echo ""
echo -e "${GREEN}现在可以启动 Claude Code 使用了!${NC}"
echo ""
