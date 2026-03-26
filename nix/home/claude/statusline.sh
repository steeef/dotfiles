#!/bin/bash
# Line 1: Model | dir@branch
# Line 2: ctx [bar] tokens pct | 5h [bar] pct @reset | 7d [bar] pct
# Source: https://github.com/daniel3303/ClaudeCodeStatusLine

set -f  # disable globbing

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# Catppuccin Macchiato palette
blue='\033[38;2;138;173;244m'    # Blue
orange='\033[38;2;245;169;127m'  # Peach
green='\033[38;2;166;218;149m'   # Green
cyan='\033[38;2;139;213;202m'    # Teal
red='\033[38;2;237;135;150m'     # Red
yellow='\033[38;2;238;212;159m'  # Yellow
white='\033[38;2;202;211;245m'   # Text
dim='\033[38;2;110;115;141m'     # Overlay0
reset='\033[0m'

# Format token counts (e.g., 50k / 200k)
format_tokens() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        awk "BEGIN {printf \"%.1fm\", $num / 1000000}"
    elif [ "$num" -ge 1000 ]; then
        awk "BEGIN {printf \"%.0fk\", $num / 1000}"
    else
        printf "%d" "$num"
    fi
}

# Return color escape based on usage percentage
usage_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then echo "$red"
    elif [ "$pct" -ge 70 ]; then echo "$orange"
    elif [ "$pct" -ge 50 ]; then echo "$yellow"
    else echo "$green"
    fi
}

# Render a progress bar: progress_bar <pct> <width>
# Uses block characters: ████░░░░
progress_bar() {
    local pct=$1
    local width=${2:-10}
    local filled=$(( pct * width / 100 ))
    [ "$filled" -gt "$width" ] && filled=$width
    local empty=$(( width - filled ))
    local color
    color=$(usage_color "$pct")
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    printf "%b%s%b" "$color" "$bar" "$reset"
}

# ===== Extract data from JSON =====
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Context window
size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
[ "$size" -eq 0 ] 2>/dev/null && size=200000

# Token usage
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
current=$(( input_tokens + cache_create + cache_read ))

used_tokens=$(format_tokens $current)
total_tokens=$(format_tokens $size)

if [ "$size" -gt 0 ]; then
    pct_used=$(( current * 100 / size ))
else
    pct_used=0
fi
# ===== Build output =====
sep=" ${dim}|${reset} "

# Line 1: Model + dir/git
line1=""
session_id=$(echo "$input" | jq -r '.session_id // empty')
line1+="${blue}${model_name}${reset}"
if [ -n "$session_id" ]; then
    short_id="${session_id:0:8}"
    line1+=" ${dim}${short_id}${reset}"
fi

cwd=$(echo "$input" | jq -r '.cwd // empty')
if [ -n "$cwd" ]; then
    display_dir="${cwd##*/}"
    git_branch=$(git -C "${cwd}" rev-parse --abbrev-ref HEAD 2>/dev/null)
    git_common_dir=$(git -C "${cwd}" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    # Strip /.git suffix to get the actual repo root (works for both regular repos and worktrees)
    repo_root="${git_common_dir%/.git}"
    repo_name="${repo_root##*/}"
    line1+="${sep}"
    if [ -n "$repo_name" ] && [ "$repo_name" != "$display_dir" ]; then
        line1+="${cyan}${repo_name}${reset} ${dim}>${reset} ${cyan}${display_dir}${reset}"
    else
        line1+="${cyan}${display_dir}${reset}"
    fi
    if [ -n "$git_branch" ]; then
        line1+="${dim}@${reset}${green}${git_branch}${reset}"
        git_stat=$(git -C "${cwd}" diff --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {if (a+d>0) printf "+%d -%d", a, d}')
        [ -n "$git_stat" ] && line1+=" ${dim}(${reset}${green}${git_stat%% *}${reset} ${red}${git_stat##* }${reset}${dim})${reset}"
    fi
fi

# Line 2: context bar + 5h bar
ctx_bar=$(progress_bar "$pct_used" 10)
line2="ctx ${ctx_bar} ${orange}${used_tokens}/${total_tokens}${reset} ${dim}${pct_used}%${reset}"

# Cross-platform ISO to epoch conversion
iso_to_epoch() {
    local iso_str="$1"

    # Try GNU date first (Linux)
    local epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    # BSD date (macOS)
    local stripped="${iso_str%%.*}"
    stripped="${stripped%%Z}"
    stripped="${stripped%%+*}"
    stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"

    if [[ "$iso_str" == *"Z"* ]] || [[ "$iso_str" == *"+00:00"* ]] || [[ "$iso_str" == *"-00:00"* ]]; then
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    fi

    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    return 1
}

# Format ISO reset time to compact local time (e.g. "3:45pm")
format_reset_time() {
    local iso_str="$1"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return

    local epoch
    epoch=$(iso_to_epoch "$iso_str")
    [ -z "$epoch" ] && return

    local formatted
    formatted=$(date -j -r "$epoch" +"%H:%M" 2>/dev/null)
    if [ -z "$formatted" ]; then
        formatted=$(date -d "@$epoch" +"%H:%M" 2>/dev/null)
    fi
    [ -n "$formatted" ] && printf "%s" "$formatted"
}

# Format ISO reset time to day+time (e.g. "Thu 14:30") for weekly window
format_reset_time_with_day() {
    local iso_str="$1"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return

    local epoch
    epoch=$(iso_to_epoch "$iso_str")
    [ -z "$epoch" ] && return

    local formatted
    formatted=$(date -j -r "$epoch" +"%a %H:%M" 2>/dev/null)
    if [ -z "$formatted" ]; then
        formatted=$(date -d "@$epoch" +"%a %H:%M" 2>/dev/null)
    fi
    [ -n "$formatted" ] && printf "%s" "$formatted"
}

# ===== Cross-platform OAuth token resolution =====
# Tries credential sources in order: env var > macOS Keychain > Linux creds file > GNOME Keyring
get_oauth_token() {
    local token=""

    # 1. Explicit env var override
    if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
        echo "$CLAUDE_CODE_OAUTH_TOKEN"
        return 0
    fi

    # 2. macOS Keychain
    if command -v security >/dev/null 2>&1; then
        local blob
        blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    # 3. Linux credentials file
    local creds_file="${HOME}/.claude/.credentials.json"
    if [ -f "$creds_file" ]; then
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        if [ -n "$token" ] && [ "$token" != "null" ]; then
            echo "$token"
            return 0
        fi
    fi

    # 4. GNOME Keyring via secret-tool
    if command -v secret-tool >/dev/null 2>&1; then
        local blob
        blob=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    echo ""
}

# ===== Usage limits with progress bars (cached) =====
cache_file="/tmp/claude/statusline-usage-cache.json"
cache_max_age=60  # seconds between API calls
mkdir -p /tmp/claude

needs_refresh=true
usage_data=""

# Check cache
if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    if [ "$cache_age" -lt "$cache_max_age" ]; then
        needs_refresh=false
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

# Fetch fresh data if cache is stale
if $needs_refresh; then
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 10 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.34" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
            # Preserve resets_at from previous cache when new response omits them
            if [ -f "$cache_file" ]; then
                prev_cache=$(cat "$cache_file" 2>/dev/null)
                if echo "$prev_cache" | jq -e . >/dev/null 2>&1; then
                    now=$(date +%s)
                    for window in five_hour seven_day; do
                        # Only merge if the fresh response has this window object
                        has_window=$(echo "$response" | jq -e ".${window}" >/dev/null 2>&1 && echo true || echo false)
                        [ "$has_window" = "false" ] && continue
                        new_reset=$(echo "$response" | jq -r ".${window}.resets_at // empty")
                        if [ -z "$new_reset" ]; then
                            old_reset=$(echo "$prev_cache" | jq -r ".${window}.resets_at // empty")
                            if [ -n "$old_reset" ]; then
                                old_epoch=$(iso_to_epoch "$old_reset")
                                if [ -n "$old_epoch" ] && [ "$old_epoch" -gt "$now" ]; then
                                    response=$(echo "$response" | jq --arg r "$old_reset" ".${window}.resets_at = \$r")
                                fi
                            fi
                        fi
                    done
                fi
            fi
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    # Fall back to stale cache
    if [ -z "$usage_data" ] && [ -f "$cache_file" ]; then
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

if [ -n "$usage_data" ] && echo "$usage_data" | jq -e '.five_hour // .seven_day' >/dev/null 2>&1; then
    five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')

    # Only show 5h bar when it has meaningful data (>0% or approaching limit)
    if [ "$five_hour_pct" -gt 0 ]; then
        five_hour_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
        five_hour_reset=$(format_reset_time "$five_hour_reset_iso")
        if [ "$five_hour_pct" -ge 95 ]; then
            line2+="${sep}5h ${red}BLOCKED${reset}"
            [ -n "$five_hour_reset" ] && line2+=" ${red}resets @${five_hour_reset}${reset}"
        else
            five_bar=$(progress_bar "$five_hour_pct" 10)
            line2+="${sep}5h ${five_bar} ${dim}${five_hour_pct}%${reset}"
            [ -n "$five_hour_reset" ] && line2+=" ${dim}@${five_hour_reset}${reset}"
        fi
    fi

    # Aggregate 7d usage
    seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_day_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
    seven_day_reset=$(format_reset_time_with_day "$seven_day_reset_iso")
    seven_bar=$(progress_bar "$seven_day_pct" 10)
    line2+="${sep}7d ${seven_bar} ${dim}${seven_day_pct}%${reset}"
    [ -n "$seven_day_reset" ] && line2+=" ${dim}@${seven_day_reset}${reset}"

    # Per-model 7d breakdowns (Enterprise) — show compact inline when present
    model_suffix=""
    for model_key in seven_day_opus seven_day_sonnet; do
        model_pct=$(echo "$usage_data" | jq -r ".${model_key}.utilization // empty" 2>/dev/null)
        if [ -n "$model_pct" ] && [ "$model_pct" != "null" ]; then
            model_pct_int=$(echo "$model_pct" | awk '{printf "%.0f", $1}')
            model_label="${model_key#seven_day_}"  # strip prefix → "opus" or "sonnet"
            model_label="${model_label:0:1}"        # first char → "o" or "s"
            model_color=$(usage_color "$model_pct_int")
            model_suffix+=" ${model_color}${model_label}:${model_pct_int}%${reset}"
        fi
    done
    [ -n "$model_suffix" ] && line2+="${model_suffix}"
fi

# Output two lines
printf "%b\n%b" "$line1" "$line2"

exit 0
