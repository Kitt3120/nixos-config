# steam-batch-edit-launch-options
#
# Interactively view, set, or clear Steam "Launch Options" for many games at
# once, by directly (and carefully) parsing/editing the local Steam user's
# `localconfig.vdf`. Only local files are used, no Steam Web API is involved.
#
# Requirements:
#   - bash, coreutils, sed, procps (pgrep), fzf - all provided as runtime
#     inputs by the Nix package wrapping this script.
#
# Installation:
#   This script is wired up as a Nix package via `writeShellApplication`
#   (see programs/steam-batch-edit-launch-options.nix). Install it through
#   your NixOS configuration like any other program in this repo.
#
# Usage:
#   steam-batch-edit-launch-options [options]
#
#   Options:
#     --user <steam-user-id>   Use a specific Steam user ID, skips the prompt
#     --steam-root <path>      Use a specific Steam installation root
#     --force                  Skip the "Steam must be closed" check
#     --dry-run                Prepare and show changes without writing them
#     --help                   Show usage information and exit
#
# Examples:
#   steam-batch-edit-launch-options
#   steam-batch-edit-launch-options --dry-run
#   steam-batch-edit-launch-options --user 123456789 --force
#
# Safety notes:
#   - Steam must be closed before changes are written (it overwrites
#     localconfig.vdf on exit), unless --force is given.
#   - A timestamped backup of localconfig.vdf is created before every write.
#   - New file contents are generated, validated by re-parsing them, and
#     only then atomically moved into place. If parsing or validation fails
#     at any point, nothing is written.
#   - Only the "LaunchOptions" entries of the selected games are touched.
#     Everything else in localconfig.vdf is preserved byte-for-byte.

# ---------------------------------------------------------------------------
# Global state
# ---------------------------------------------------------------------------

FORCE=0
DRY_RUN=0
CLI_USER=""
CLI_STEAM_ROOT=""

STEAM_ROOT=""
STEAM_USER_ID=""
LOCALCONFIG_PATH=""

# Populated by parse_localconfig() for the file currently being parsed.
declare -a PARSED_LINES=()
declare -a APP_IDS=()
declare -A APP_START_LINE=()
declare -A APP_LOPT_LINE=()
declare -A APP_LOPT_VALUE=()
declare -A APP_LOPT_INDENT=()
declare -A APP_LOPT_WS=()
declare -A APP_NAME=()

# Populated by rebuild_game_index(): parallel arrays describing every game.
declare -a GAME_APPID=()
declare -a GAME_NAME=()
declare -a GAME_LAUNCHOPTS=()

# Unique LaunchOptions values, "no options" (empty string) always first.
declare -a GROUP_KEYS=()

# Game indices grouped by launch options, used for stable on-screen numbering.
declare -a DISPLAY_ORDER=()

# Result of select_games(): the chosen AppIDs.
declare -a SELECTED_APPIDS=()

# Populated by discover_steam_users().
declare -a USER_ROOT=()
declare -a USER_ID=()
declare -a USER_LABEL=()

# The exact key path under which Steam stores per-game local configuration.
readonly -a VDF_APPS_PATH=("UserLocalConfigStore" "Software" "Valve" "Steam" "apps")

# ---------------------------------------------------------------------------
# Logging helpers
# ---------------------------------------------------------------------------

log_warn() {
    printf 'Warning: %s\n' "$*" >&2
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

# ---------------------------------------------------------------------------
# VDF string escaping
#
# Valve's KeyValues format escapes backslashes and double quotes inside
# string values as \\ and \" respectively. These helpers convert between the
# raw (unescaped) value used internally and the escaped form stored on disk.
# ---------------------------------------------------------------------------

escape_vdf_value() {
    local value=$1
    value=$(printf '%s' "$value" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
    printf '%s' "$value"
}

unescape_vdf_value() {
    local value=$1
    # Escaped quotes are converted via a placeholder first so that a
    # preceding escaped backslash isn't mistaken for part of the sequence.
    value=$(printf '%s' "$value" | sed -e 's/\\"/\x01/g' -e 's/\\\\/\\/g' -e 's/\x01/"/g')
    printf '%s' "$value"
}

# ---------------------------------------------------------------------------
# localconfig.vdf parsing
#
# This is a small line-oriented state machine rather than a generic VDF
# parser: it only needs to know enough about the file's brace nesting to
# find, for each AppID under Software/Valve/Steam/apps, the line holding its
# "LaunchOptions" entry (if any), while leaving every other line untouched.
# ---------------------------------------------------------------------------

parse_localconfig() {
    local file=$1

    [[ -f $file ]] || die "Steam configuration file not found: $file"

    PARSED_LINES=()
    mapfile -t PARSED_LINES <"$file"
    (( ${#PARSED_LINES[@]} > 0 )) || die "Steam configuration file is empty: $file"

    APP_IDS=()
    APP_START_LINE=()
    APP_LOPT_LINE=()
    APP_LOPT_VALUE=()
    APP_LOPT_INDENT=()
    APP_LOPT_WS=()
    APP_NAME=()

    local -a stack=()
    local pending_key="" apps_depth=-1 apps_found=0

    local -r open_brace_re='^[[:space:]]*\{[[:space:]]*$'
    local -r close_brace_re='^[[:space:]]*\}[[:space:]]*$'
    local -r key_only_re='^[[:space:]]*"((\\.|[^"\\])*)"[[:space:]]*$'
    local -r key_value_re='^([[:space:]]*)"((\\.|[^"\\])*)"([[:space:]]+)"((\\.|[^"\\])*)"[[:space:]]*$'

    local i line
    for i in "${!PARSED_LINES[@]}"; do
        line="${PARSED_LINES[$i]}"

        if [[ $line =~ $open_brace_re ]]; then
            [[ -n $pending_key ]] || die "Malformed VDF: unexpected '{' at line $((i + 1)) in $file"
            stack+=("$pending_key")
            pending_key=""

            if (( ${#stack[@]} == 5 )) \
                && [[ ${stack[0]} == "${VDF_APPS_PATH[0]}" && ${stack[1]} == "${VDF_APPS_PATH[1]}" \
                    && ${stack[2]} == "${VDF_APPS_PATH[2]}" && ${stack[3]} == "${VDF_APPS_PATH[3]}" \
                    && ${stack[4]} == "${VDF_APPS_PATH[4]}" ]]; then
                apps_depth=${#stack[@]}
                apps_found=1
            fi

            if (( apps_depth >= 0 )) && (( ${#stack[@]} == apps_depth + 1 )); then
                local appid="${stack[-1]}"
                if [[ $appid =~ ^[0-9]+$ ]]; then
                    APP_START_LINE[$appid]=$i
                    APP_IDS+=("$appid")
                fi
            fi
            continue
        fi

        if [[ $line =~ $close_brace_re ]]; then
            (( ${#stack[@]} > 0 )) || die "Malformed VDF: unexpected '}' at line $((i + 1)) in $file"

            if (( apps_depth >= 0 )) && (( ${#stack[@]} == apps_depth )); then
                apps_depth=-1
            fi

            unset 'stack[-1]'
            continue
        fi

        if [[ $line =~ $key_value_re ]]; then
            local kv_indent="${BASH_REMATCH[1]}"
            local kv_ws="${BASH_REMATCH[4]}"
            local key value
            key=$(unescape_vdf_value "${BASH_REMATCH[2]}")
            value=$(unescape_vdf_value "${BASH_REMATCH[5]}")

            if (( apps_depth >= 0 )) && (( ${#stack[@]} == apps_depth + 1 )); then
                local current_appid="${stack[-1]}"
                if [[ $key == "LaunchOptions" ]]; then
                    APP_LOPT_LINE[$current_appid]=$i
                    APP_LOPT_VALUE[$current_appid]="$value"
                    APP_LOPT_INDENT[$current_appid]="$kv_indent"
                    APP_LOPT_WS[$current_appid]="$kv_ws"
                elif [[ $key == "name" || $key == "Name" ]]; then
                    APP_NAME[$current_appid]="$value"
                fi
            fi
            pending_key=""
            continue
        fi

        if [[ $line =~ $key_only_re ]]; then
            pending_key=$(unescape_vdf_value "${BASH_REMATCH[1]}")
            continue
        fi

        if [[ -z ${line//[[:space:]]/} ]]; then
            continue
        fi

        die "Malformed or unsupported VDF syntax at line $((i + 1)) in $file"
    done

    (( ${#stack[@]} == 0 )) || die "Malformed VDF: unbalanced braces in $file"
    (( apps_found == 1 )) || die "Could not find the Steam apps section (UserLocalConfigStore/Software/Valve/Steam/apps) in $file"
}

# ---------------------------------------------------------------------------
# Steam installation / user discovery
# ---------------------------------------------------------------------------

discover_steam_roots() {
    if [[ -n $CLI_STEAM_ROOT ]]; then
        [[ -d $CLI_STEAM_ROOT ]] || die "Steam root not found: $CLI_STEAM_ROOT"
        printf '%s\n' "$CLI_STEAM_ROOT"
        return 0
    fi

    local -a candidates=("$HOME/.local/share/Steam" "$HOME/.steam/steam" "$HOME/.steam/root")
    local -A seen=()
    local -a roots=()
    local candidate resolved

    for candidate in "${candidates[@]}"; do
        [[ -d $candidate ]] || continue
        resolved=$(cd "$candidate" 2>/dev/null && pwd -P) || continue
        [[ -d "$resolved/userdata" ]] || continue
        [[ -n ${seen[$resolved]+x} ]] && continue
        seen[$resolved]=1
        roots+=("$resolved")
    done

    (( ${#roots[@]} > 0 )) || die "No Steam installation found. Use --steam-root to specify one manually."
    printf '%s\n' "${roots[@]}"
}

# Looks up the persona/account name for a Steam3 account ID by scanning
# config/loginusers.vdf, which is keyed by the 64-bit SteamID.
get_persona_name() {
    local root=$1 account_id=$2
    local loginusers_file="$root/config/loginusers.vdf"
    [[ -f $loginusers_file ]] || return 1

    local steamid64=$((account_id + 76561197960265728))
    local line in_block=0 depth=0 persona="" account=""

    while IFS= read -r line; do
        if (( in_block == 0 )); then
            [[ $line == *"\"$steamid64\""* ]] && in_block=1
            continue
        fi

        if [[ $line == *"{"* ]]; then
            depth=$((depth + 1))
            continue
        fi

        if [[ $line == *"}"* ]]; then
            depth=$((depth - 1))
            (( depth <= 0 )) && break
            continue
        fi

        if [[ $line =~ \"PersonaName\"[[:space:]]+\"((\\.|[^\"\\])*)\" ]]; then
            persona="${BASH_REMATCH[1]}"
        elif [[ $line =~ \"AccountName\"[[:space:]]+\"((\\.|[^\"\\])*)\" ]]; then
            account="${BASH_REMATCH[1]}"
        fi
    done <"$loginusers_file"

    if [[ -n $persona ]]; then
        unescape_vdf_value "$persona"
        return 0
    fi
    if [[ -n $account ]]; then
        unescape_vdf_value "$account"
        return 0
    fi
    return 1
}

discover_steam_users() {
    USER_ROOT=()
    USER_ID=()
    USER_LABEL=()

    local -a roots
    mapfile -t roots < <(discover_steam_roots)

    local root userdir userid label persona
    for root in "${roots[@]}"; do
        [[ -d "$root/userdata" ]] || continue
        for userdir in "$root"/userdata/*/; do
            [[ -d $userdir ]] || continue
            userid=$(basename "$userdir")
            [[ $userid =~ ^[0-9]+$ ]] || continue
            [[ -f "${userdir}config/localconfig.vdf" ]] || continue

            label="$userid"
            if persona=$(get_persona_name "$root" "$userid"); then
                [[ -n $persona ]] && label="${userid} - ${persona}"
            fi

            USER_ROOT+=("$root")
            USER_ID+=("$userid")
            USER_LABEL+=("$label")
        done
    done

    (( ${#USER_ID[@]} > 0 )) || die "No Steam user configuration found under any detected Steam installation."
}

select_steam_user() {
    discover_steam_users

    local -a indices=()
    local i
    if [[ -n $CLI_USER ]]; then
        for i in "${!USER_ID[@]}"; do
            [[ ${USER_ID[$i]} == "$CLI_USER" ]] && indices+=("$i")
        done
        (( ${#indices[@]} > 0 )) || die "Steam user '$CLI_USER' not found."
    else
        for i in "${!USER_ID[@]}"; do
            indices+=("$i")
        done
    fi

    local chosen_index
    if (( ${#indices[@]} == 1 )); then
        chosen_index=${indices[0]}
    else
        echo
        echo "Detected Steam users:"
        echo
        local n=1
        for i in "${indices[@]}"; do
            printf '%d) %s\n' "$n" "${USER_LABEL[$i]}"
            n=$((n + 1))
        done
        echo
        local choice
        while true; do
            read -r -p "Select user: " choice || die "No input received."
            if [[ $choice =~ ^[0-9]+$ ]] && (( choice >= 1 )) && (( choice <= ${#indices[@]} )); then
                chosen_index=${indices[$((choice - 1))]}
                break
            fi
            log_warn "Invalid selection: $choice"
        done
    fi

    STEAM_ROOT="${USER_ROOT[$chosen_index]}"
    STEAM_USER_ID="${USER_ID[$chosen_index]}"
    LOCALCONFIG_PATH="${STEAM_ROOT}/userdata/${STEAM_USER_ID}/config/localconfig.vdf"
}

# ---------------------------------------------------------------------------
# Game name resolution (appmanifest fallback)
# ---------------------------------------------------------------------------

get_library_paths() {
    local root=$1
    local file="$root/steamapps/libraryfolders.vdf"
    local -a paths=("$root")

    if [[ -f $file ]]; then
        local line path
        while IFS= read -r line; do
            if [[ $line =~ \"path\"[[:space:]]+\"((\\.|[^\"\\])*)\" ]]; then
                path=$(unescape_vdf_value "${BASH_REMATCH[1]}")
                [[ $path != "$root" ]] && paths+=("$path")
            fi
        done <"$file"
    fi

    printf '%s\n' "${paths[@]}"
}

extract_acf_value() {
    local file=$1 key=$2 line
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*\"$key\"[[:space:]]+\"((\\.|[^\"\\])*)\"[[:space:]]*$ ]]; then
            unescape_vdf_value "${BASH_REMATCH[1]}"
            return 0
        fi
    done <"$file"
    return 1
}

find_game_name_from_manifest() {
    local appid=$1
    shift
    local lib manifest name
    for lib in "$@"; do
        manifest="$lib/steamapps/appmanifest_${appid}.acf"
        if [[ -f $manifest ]]; then
            if name=$(extract_acf_value "$manifest" "name"); then
                [[ -n $name ]] && { printf '%s' "$name"; return 0; }
            fi
        fi
    done
    return 1
}

# ---------------------------------------------------------------------------
# Game index / grouping
# ---------------------------------------------------------------------------

rebuild_game_index() {
    parse_localconfig "$LOCALCONFIG_PATH"

    GAME_APPID=()
    GAME_NAME=()
    GAME_LAUNCHOPTS=()

    local -a lib_paths
    mapfile -t lib_paths < <(get_library_paths "$STEAM_ROOT")

    local appid name value
    for appid in "${APP_IDS[@]}"; do
        value="${APP_LOPT_VALUE[$appid]:-}"
        name="${APP_NAME[$appid]:-}"
        if [[ -z $name ]]; then
            name=$(find_game_name_from_manifest "$appid" "${lib_paths[@]}") || name=""
        fi
        [[ -z $name ]] && name="Unknown game (${appid})"

        GAME_APPID+=("$appid")
        GAME_NAME+=("$name")
        GAME_LAUNCHOPTS+=("$value")
    done

    build_groups
}

build_groups() {
    # Bash associative arrays reject the empty string as a subscript, so the
    # "no launch options" group is tracked separately rather than via $seen.
    GROUP_KEYS=()
    local -A seen=()
    local v has_empty=0
    for v in "${GAME_LAUNCHOPTS[@]}"; do
        if [[ -z $v ]]; then
            has_empty=1
            continue
        fi
        [[ -n ${seen[$v]+x} ]] && continue
        GROUP_KEYS+=("$v")
        seen[$v]=1
    done

    (( has_empty == 1 )) && GROUP_KEYS=("" "${GROUP_KEYS[@]}")
    return 0
}

build_display_order() {
    DISPLAY_ORDER=()
    local group_value idx
    for group_value in "${GROUP_KEYS[@]}"; do
        for idx in "${!GAME_APPID[@]}"; do
            [[ ${GAME_LAUNCHOPTS[$idx]} == "$group_value" ]] && DISPLAY_ORDER+=("$idx")
        done
    done
    return 0
}

count_group_members() {
    local value=$1 count=0 idx
    for idx in "${!GAME_APPID[@]}"; do
        [[ ${GAME_LAUNCHOPTS[$idx]} == "$value" ]] && count=$((count + 1))
    done
    printf '%s' "$count"
}

name_for_appid() {
    local appid=$1 i
    for i in "${!GAME_APPID[@]}"; do
        if [[ ${GAME_APPID[$i]} == "$appid" ]]; then
            printf '%s' "${GAME_NAME[$i]}"
            return 0
        fi
    done
    printf '%s' "$appid"
}

truncate_string() {
    local str=$1 maxlen=$2
    (( maxlen < 4 )) && maxlen=4
    if (( ${#str} <= maxlen )); then
        printf '%s' "$str"
    else
        printf '%s...' "${str:0:$((maxlen - 3))}"
    fi
}

print_parse_summary() {
    local total=${#GAME_APPID[@]}
    local with_opts=0 idx
    for idx in "${!GAME_APPID[@]}"; do
        [[ -n ${GAME_LAUNCHOPTS[$idx]} ]] && with_opts=$((with_opts + 1))
    done
    local without_opts=$((total - with_opts))

    echo
    echo "Found:"
    echo "  ${total} games"
    echo "  ${with_opts} games with launch options"
    echo "  ${without_opts} games without launch options"
    echo "  ${#GROUP_KEYS[@]} distinct launch option groups"
}

# ---------------------------------------------------------------------------
# Game selection UI
# ---------------------------------------------------------------------------

select_games() {
    SELECTED_APPIDS=()
    build_display_order

    local -a fzf_lines=()
    local idx group_label prev_value="" have_prev=0 group_no=-1
    for idx in "${DISPLAY_ORDER[@]}"; do
        if (( have_prev == 0 )) || [[ ${GAME_LAUNCHOPTS[$idx]} != "$prev_value" ]]; then
            group_no=$((group_no + 1))
            prev_value="${GAME_LAUNCHOPTS[$idx]}"
            have_prev=1
        fi
        if [[ -z ${GAME_LAUNCHOPTS[$idx]} ]]; then
            group_label="No Launch Options"
        else
            group_label=$(truncate_string "${GAME_LAUNCHOPTS[$idx]}" 40)
        fi
        # Field 1 (group_no) is a hidden plain integer used for Ctrl-G/Alt-G group
        # matching via an anchored "^N<tab>" query, since --nth can't scope to
        # fields hidden by --with-nth; field 5 (idx) stays last for extraction.
        fzf_lines+=("$(printf '%s\t%s\t%s\t[%s]\t%s' "$group_no" "$group_label" "${GAME_NAME[$idx]}" "${GAME_APPID[$idx]}" "$idx")")
    done

    local -a chosen
    mapfile -t chosen < <(printf '%s\n' "${fzf_lines[@]}" | fzf --multi \
        --delimiter="$(printf '\t')" --with-nth=2,3,4 \
        --header=$'Tab: toggle select  Ctrl-A: select all filtered  Ctrl-D: deselect all filtered  Ctrl-T: toggle all filtered  Enter: confirm  Esc: cancel\nCtrl-G: select group of current entry  Alt-G: deselect group of current entry\nType part of a group name to filter, then Ctrl-A/Ctrl-D to select/deselect the whole group.' \
        --bind 'ctrl-a:select-all' \
        --bind 'ctrl-d:deselect-all' \
        --bind 'ctrl-t:toggle-all' \
        --bind 'ctrl-g:transform-query(printf "^%s\t" {1})+wait+select-all+clear-query' \
        --bind 'alt-g:transform-query(printf "^%s\t" {1})+wait+deselect-all+clear-query' \
        --prompt="Select games> ")

    (( ${#chosen[@]} > 0 )) || return 1

    SELECTED_APPIDS=()
    local line game_idx
    for line in "${chosen[@]}"; do
        game_idx="${line##*$'\t'}"
        SELECTED_APPIDS+=("${GAME_APPID[$game_idx]}")
    done
    return 0
}

# ---------------------------------------------------------------------------
# Actions
# ---------------------------------------------------------------------------

print_confirmation_summary() {
    local action_label=$1 new_value=$2
    shift 2
    local -a appids=("$@")

    echo
    echo "Action:"
    echo "  ${action_label}"
    if [[ -n $new_value ]]; then
        echo
        echo "New launch options:"
        echo "  ${new_value}"
    fi
    echo
    echo "Affected games: ${#appids[@]}"
    echo
    local appid
    for appid in "${appids[@]}"; do
        echo "  - $(name_for_appid "$appid")"
    done
    echo
}

confirm_action() {
    local reply
    read -r -p "Proceed? [y/N] " reply || reply=""
    [[ $reply =~ ^[Yy]([Ee][Ss])?$ ]]
}

action_set_launch_options() {
    echo
    echo "Enter new launch options:"
    local new_value
    read -r -p "> " new_value || return
    if [[ -z $new_value ]]; then
        log_warn "No launch options entered. Use 'Clear launch options' to remove existing options instead."
        return
    fi

    if ! select_games; then
        log_warn "Selection cancelled."
        return
    fi
    (( ${#SELECTED_APPIDS[@]} > 0 )) || { log_warn "No games selected."; return; }

    print_confirmation_summary "Set launch options" "$new_value" "${SELECTED_APPIDS[@]}"
    if confirm_action; then
        apply_change "set" "$new_value" "${SELECTED_APPIDS[@]}"
    else
        echo "Cancelled. No changes made."
    fi
}

action_clear_launch_options() {
    if ! select_games; then
        log_warn "Selection cancelled."
        return
    fi
    (( ${#SELECTED_APPIDS[@]} > 0 )) || { log_warn "No games selected."; return; }

    print_confirmation_summary "Clear launch options" "" "${SELECTED_APPIDS[@]}"
    if confirm_action; then
        apply_change "clear" "" "${SELECTED_APPIDS[@]}"
    else
        echo "Cancelled. No changes made."
    fi
}

action_show_groups() {
    build_display_order

    echo
    echo "Launch option groups:"
    local prev_value="" have_prev=0 idx value count
    for idx in "${DISPLAY_ORDER[@]}"; do
        value="${GAME_LAUNCHOPTS[$idx]}"
        if (( have_prev == 0 )) || [[ $value != "$prev_value" ]]; then
            (( have_prev == 1 )) && echo
            count=$(count_group_members "$value")
            if [[ -z $value ]]; then
                echo "=== No Launch Options (${count}) ==="
            else
                echo "=== Launch Options (${count}) ==="
                echo "$value"
            fi
            echo
            prev_value="$value"
            have_prev=1
        fi
        echo "  - ${GAME_NAME[$idx]} [${GAME_APPID[$idx]}]"
    done
    echo
    read -r -p "Press Enter to return to the main menu..." || true
}

# ---------------------------------------------------------------------------
# Steam running check
# ---------------------------------------------------------------------------

is_steam_running() {
    pgrep -x steam >/dev/null 2>&1 && return 0
    pgrep -f steamwebhelper >/dev/null 2>&1 && return 0
    return 1
}

check_steam_not_running() {
    (( FORCE == 1 )) && return 0
    if is_steam_running; then
        die "$(printf 'Steam is currently running.\n\nPlease close Steam before modifying localconfig.vdf, or re-run with --force.')"
    fi
}

# ---------------------------------------------------------------------------
# Applying changes: parse -> mutate -> validate -> backup -> atomic replace
# ---------------------------------------------------------------------------

apply_change() {
    local action=$1 new_value=$2
    shift 2
    local -a target_appids=("$@")

    (( ${#target_appids[@]} > 0 )) || { log_warn "No games selected, nothing to do."; return 0; }

    parse_localconfig "$LOCALCONFIG_PATH"

    local appid
    for appid in "${target_appids[@]}"; do
        [[ -n ${APP_START_LINE[$appid]+x} ]] \
            || die "Game ${appid} disappeared from the Steam configuration, aborting to avoid an inconsistent state."
    done

    local escaped_value=""
    [[ $action == "set" ]] && escaped_value=$(escape_vdf_value "$new_value")

    local -A replace_line=()
    local -A insert_after=()
    local -A delete_line=()

    for appid in "${target_appids[@]}"; do
        if [[ $action == "set" ]]; then
            if [[ -n ${APP_LOPT_LINE[$appid]+x} ]]; then
                local line_no=${APP_LOPT_LINE[$appid]}
                replace_line[$line_no]="${APP_LOPT_INDENT[$appid]}\"LaunchOptions\"${APP_LOPT_WS[$appid]}\"${escaped_value}\""
            else
                local brace_line=${APP_START_LINE[$appid]}
                local brace_indent=""
                [[ ${PARSED_LINES[$brace_line]} =~ ^([[:space:]]*)\{ ]] && brace_indent="${BASH_REMATCH[1]}"
                insert_after[$brace_line]="${brace_indent}"$'\t'"\"LaunchOptions\""$'\t'"\"${escaped_value}\""
            fi
        else
            [[ -n ${APP_LOPT_LINE[$appid]+x} ]] && delete_line[${APP_LOPT_LINE[$appid]}]=1
        fi
    done

    local -a new_lines=()
    local idx
    for idx in "${!PARSED_LINES[@]}"; do
        [[ -n ${delete_line[$idx]+x} ]] && continue
        if [[ -n ${replace_line[$idx]+x} ]]; then
            new_lines+=("${replace_line[$idx]}")
        else
            new_lines+=("${PARSED_LINES[$idx]}")
        fi
        [[ -n ${insert_after[$idx]+x} ]] && new_lines+=("${insert_after[$idx]}")
    done

    local config_dir tmp_file
    config_dir=$(dirname "$LOCALCONFIG_PATH")
    tmp_file=$(mktemp "${config_dir}/.localconfig.vdf.tmp.XXXXXX") || die "Failed to create a temporary file."

    if ! printf '%s\n' "${new_lines[@]}" >"$tmp_file"; then
        rm -f "$tmp_file"
        die "Failed to write the temporary configuration file."
    fi

    # Validate by re-parsing the freshly generated file before touching anything real.
    parse_localconfig "$tmp_file"
    for appid in "${target_appids[@]}"; do
        local actual="${APP_LOPT_VALUE[$appid]:-}"
        if [[ $action == "set" ]]; then
            if [[ $actual != "$new_value" ]]; then
                rm -f "$tmp_file"
                die "Validation failed for AppID ${appid}, aborting without changes."
            fi
        else
            if [[ -n $actual ]]; then
                rm -f "$tmp_file"
                die "Validation failed for AppID ${appid} (LaunchOptions still present), aborting without changes."
            fi
        fi
    done

    if (( DRY_RUN == 1 )); then
        echo
        echo "[dry-run] Validation succeeded. The following games would be updated:"
        for appid in "${target_appids[@]}"; do
            echo "  - $(name_for_appid "$appid")"
        done
        echo "No changes were written."
        rm -f "$tmp_file"
        return 0
    fi

    check_steam_not_running

    local backup_path
    backup_path="${LOCALCONFIG_PATH}.backup-$(date +%Y-%m-%d-%H%M%S)"
    if ! cp -p "$LOCALCONFIG_PATH" "$backup_path"; then
        rm -f "$tmp_file"
        die "Failed to create a backup, aborting without changes."
    fi
    echo "Backup created:"
    echo "  ${backup_path}"

    chmod --reference="$LOCALCONFIG_PATH" "$tmp_file" 2>/dev/null || true
    if ! mv -f "$tmp_file" "$LOCALCONFIG_PATH"; then
        die "Failed to write the configuration file. A backup is available at ${backup_path}"
    fi

    echo "Launch options updated successfully."
    rebuild_game_index
}

# ---------------------------------------------------------------------------
# Main menu / CLI
# ---------------------------------------------------------------------------

main_menu() {
    while true; do
        echo
        echo "Main Menu"
        echo
        echo "1) Set launch options"
        echo "2) Clear launch options"
        echo "3) Show launch option groups"
        echo "4) Exit"
        echo
        local choice
        read -r -p "> " choice || choice="4"
        case "$choice" in
            1) action_set_launch_options ;;
            2) action_clear_launch_options ;;
            3) action_show_groups ;;
            4 | q | quit | exit)
                echo "Goodbye."
                return 0
                ;;
            *) log_warn "Invalid choice: $choice" ;;
        esac
    done
}

print_usage() {
    cat <<'EOF'
steam-batch-edit-launch-options

Interactively view, set, or clear Steam launch options for many games at
once, by directly parsing and editing the local Steam user's localconfig.vdf.

Usage:
  steam-batch-edit-launch-options [options]

Options:
  --user <steam-user-id>   Use a specific Steam user ID (skips the prompt)
  --steam-root <path>      Use a specific Steam installation root
  --force                  Skip the "Steam must be closed" check
  --dry-run                Prepare and show changes without writing them
  --help                   Show this help text and exit

Steam must be closed before changes are written, since Steam overwrites
localconfig.vdf on exit. A timestamped backup is created next to the
original file before every change, and writes are atomic.
EOF
}

parse_args() {
    while (( $# > 0 )); do
        case "$1" in
            --user)
                CLI_USER=${2:?"--user requires a value"}
                shift 2
                ;;
            --user=*)
                CLI_USER="${1#*=}"
                shift
                ;;
            --steam-root)
                CLI_STEAM_ROOT=${2:?"--steam-root requires a value"}
                shift 2
                ;;
            --steam-root=*)
                CLI_STEAM_ROOT="${1#*=}"
                shift
                ;;
            --force)
                FORCE=1
                shift
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --help | -h)
                print_usage
                exit 0
                ;;
            *)
                die "Unknown option: $1 (use --help for usage)"
                ;;
        esac
    done
}

main() {
    parse_args "$@"

    select_steam_user

    echo
    echo "Using Steam configuration:"
    echo "  ${LOCALCONFIG_PATH}"

    echo
    echo "Parsing Steam configuration..."
    rebuild_game_index
    print_parse_summary

    main_menu
}

main "$@"
