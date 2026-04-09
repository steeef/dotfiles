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
    awk -v n="$1" 'BEGIN {
        if (n >= 1000000) printf "%.1fm", n / 1000000
        else if (n >= 1000) printf "%.0fk", n / 1000
        else printf "%d", n
    }'
}

# Return color escape based on usage percentage
usage_color_result=""
usage_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then usage_color_result=$red
    elif [ "$pct" -ge 70 ]; then usage_color_result=$orange
    elif [ "$pct" -ge 50 ]; then usage_color_result=$yellow
    else usage_color_result=$green
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
    usage_color "$pct"
    local color=$usage_color_result
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    printf "%b%s%b" "$color" "$bar" "$reset"
}

# ===== Extract data from JSON =====
IFS=$'\n' read -r -d '' model_name size input_tokens cache_create cache_read session_id cwd c_sess < <(
    jq -r '[
        (.model.display_name // "Claude" | tostring),
        (.context_window.context_window_size // 200000 | tostring),
        (.context_window.current_usage.input_tokens // 0 | tostring),
        (.context_window.current_usage.cache_creation_input_tokens // 0 | tostring),
        (.context_window.current_usage.cache_read_input_tokens // 0 | tostring),
        (.session_id // ""),
        (.cwd // ""),
        (if .cost.total_cost_usd == null then "" else (.cost.total_cost_usd | tostring) end)
    ] | .[]' <<< "$input"
    printf '\0'
)
current=$(( input_tokens + cache_create + cache_read ))

used_tokens=$(format_tokens "$current")
total_tokens=$(format_tokens "$size")

if [ "$size" -gt 0 ]; then
    pct_used=$(( current * 100 / size ))
else
    pct_used=0
fi
# ===== Build output =====
sep=" ${dim}|${reset} "

# Line 1: Model | session | dir/git
line1=""
line1+="${blue}${model_name}${reset}"
if [ -n "$session_id" ]; then
    short_id="${session_id:0:8}"
    line1+="${sep}${dim}${short_id}${reset}"
fi

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
    local iso_str="$1" fmt="${2:-%H:%M}"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return

    local epoch; epoch=$(iso_to_epoch "$iso_str") || return
    local formatted
    formatted=$(date -j -r "$epoch" +"$fmt" 2>/dev/null) || \
    formatted=$(date -d "@$epoch" +"$fmt" 2>/dev/null)
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
            token=$(jq -r '.claudeAiOauth.accessToken // empty' <<< "$blob" 2>/dev/null)
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
            token=$(jq -r '.claudeAiOauth.accessToken // empty' <<< "$blob" 2>/dev/null)
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
cached_json=""
[ -f "$cache_file" ] && cached_json=$(cat "$cache_file" 2>/dev/null)

# Check cache
if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    if [ "$cache_age" -lt "$cache_max_age" ]; then
        needs_refresh=false
        usage_data=$cached_json
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
        if [ -n "$response" ] && jq -e '.five_hour' <<< "$response" >/dev/null 2>&1; then
            # Preserve resets_at from previous cache when new response omits them
            if [ -n "$cached_json" ]; then
                prev_cache=$cached_json
                if jq -e . <<< "$prev_cache" >/dev/null 2>&1; then
                    now=$(date +%s)
                    for window in five_hour seven_day; do
                        jq -e ".${window}" <<< "$response" >/dev/null 2>&1 || continue
                        new_reset=$(jq -r ".${window}.resets_at // empty" <<< "$response")
                        [ -n "$new_reset" ] && continue
                        old_reset=$(jq -r ".${window}.resets_at // empty" <<< "$prev_cache")
                        [ -z "$old_reset" ] && continue
                        old_epoch=$(iso_to_epoch "$old_reset")
                        [ -n "$old_epoch" ] && [ "$old_epoch" -gt "$now" ] || continue
                        response=$(jq --arg r "$old_reset" ".${window}.resets_at = \$r" <<< "$response")
                    done
                fi
            fi
            usage_data="$response"
            cached_json=$response
            echo "$response" > "$cache_file"
        fi
    fi
    # Fall back to stale cache
    if [ -z "$usage_data" ]; then
        usage_data=$cached_json
    fi
fi

if [ -n "$usage_data" ] && jq -e '.five_hour // .seven_day' <<< "$usage_data" >/dev/null 2>&1; then
    IFS=$'\n' read -r -d '' five_hour_pct five_hour_reset_iso seven_day_pct seven_day_reset_iso seven_day_opus_pct seven_day_sonnet_pct < <(
        jq -r '[
            (.five_hour.utilization // 0 | round | tostring),
            (.five_hour.resets_at // ""),
            (.seven_day.utilization // 0 | round | tostring),
            (.seven_day.resets_at // ""),
            (if .seven_day_opus.utilization? == null then "" else (.seven_day_opus.utilization | round | tostring) end),
            (if .seven_day_sonnet.utilization? == null then "" else (.seven_day_sonnet.utilization | round | tostring) end)
        ] | .[]' <<< "$usage_data"
        printf '\0'
    )

    # Only show 5h bar when it has meaningful data (>0% or approaching limit)
    if [ "$five_hour_pct" -gt 0 ]; then
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
    seven_day_reset=$(format_reset_time "$seven_day_reset_iso" "%a %H:%M")
    seven_bar=$(progress_bar "$seven_day_pct" 10)
    line2+="${sep}7d ${seven_bar} ${dim}${seven_day_pct}%${reset}"
    [ -n "$seven_day_reset" ] && line2+=" ${dim}@${seven_day_reset}${reset}"

    model_suffix=""
    for model_entry in "opus|$seven_day_opus_pct" "sonnet|$seven_day_sonnet_pct"; do
        model_label="${model_entry%%|*}"
        model_pct="${model_entry#*|}"
        if [ -n "$model_pct" ] && [ "$model_pct" != "null" ]; then
            usage_color "$model_pct"
            model_suffix+=" ${usage_color_result}${model_label:0:1}:${model_pct}%${reset}"
        fi
    done
    [ -n "$model_suffix" ] && line2+="${model_suffix}"
fi

# ===== Cost =====
# Session cost from JSON (always fresh); day/week from ccu (no cache)
if [ -n "$c_sess" ]; then
    c_sess=$(printf "%.2f" "$c_sess" 2>/dev/null)
fi

c_today=""
c_week=""
if command -v ccu >/dev/null 2>&1; then
    c_today=$(ccu today --total 2>/dev/null)
    c_week=$(ccu weekly --total 2>/dev/null)
fi

cost_str=""
for _entry in "s|$c_sess" "d|$c_today" "w|$c_week"; do
    _label="${_entry%%|*}"
    _val="${_entry#*|}"
    if [ -n "$_val" ]; then
        [ -n "$cost_str" ] && cost_str+=" "
        cost_str+="${dim}${_label}${reset} ${cyan}\$${_val}${reset}"
    fi
done
[ -n "$cost_str" ] && line2+="${sep}${cost_str}"

# Output two lines
printf "%b\n%b" "$line1" "$line2"

exit 0
