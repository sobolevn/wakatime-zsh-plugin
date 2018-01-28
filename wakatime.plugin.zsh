# shellcheck disable=SC2148
# wakatime-zsh-plguin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin

PLUGIN_VERSION="0.0.1"


_heartbeat() {
    # Sends a heartbeat to the wakarime server before each command.
    # But it can be disabled by an environment variable:
    # Set `$WAKATIME_DO_NOT_TRACK` to non-empty value to skip the tracking.
    if [[ ! -z "$WAKATIME_DO_NOT_TRACK" ]]; then
        # Tracking is skipped!
        exit 0
    fi

    local project, binary
    project=$(_current_directory)
    binary=$(_last_command)

    # TODO(@sobolevn): should we keep `sh` as the language?
    wakatime --write \
        --plugin "wakatime-zsh-plugin/$PLUGIN_VERSION" \
        --entity-type app \
        --entity "$binary" \
        --project "$project" \
        --language sh
}


_current_directory() {
    # We only take the `root` directory name.
    # We detect `root` directories by `.git` folder.
    # If we are not in the git repository,
    # take the current working directory.
    local root_directory
    root_directory=$(
        git rev-parse --show-toplevel 2>/dev/null || echo "$PWD"
    )
    echo "${root_directory##*/}"
}


_last_command() {
    # We only send the last command to the wakatime.
    # We only send the first argument, which is a binary in 99% of cases.
    # It does not include any sensitive information.
    # shellcheck disable=SC2154
    echo "$history[$((HISTCMD-1))]" | cut -d ' ' -f1
}

# See docs on what `precmd_functions` is:
# http://zsh.sourceforge.net/Doc/Release/Functions.html
precmd_functions+=(_heartbeat)
