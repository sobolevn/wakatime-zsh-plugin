# shellcheck disable=SC2148
# wakatime-zsh-plguin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin

# Constants:
PLUGIN_NAME='wakatime-zsh-plugin'
PLUGIN_VERSION='0.1.0'

# Options:
WAKATIME_TIMEOUT=${WAKATIME_TIMEOUT:-5}


_heartbeat() {
    # Sends a heartbeat to the wakarime server before each command.
    # But it can be disabled by an environment variable:
    # Set `$WAKATIME_DO_NOT_TRACK` to non-empty value to skip the tracking.
    if [[ ! -z "$WAKATIME_DO_NOT_TRACK" ]]; then
        # Tracking is skipped!
        return
    fi

    # Checks if `wakatime` is installed:
    if [[ ! "$(command -v wakatime)" ]]; then
        echo "wakatime is not installed, run:"
        echo "$ pip install wakatime"
        echo
        echo "Time is not tracked for now."
        return
    fi

    # We need this line to track exception messages for wakatime:
    trap '_handle_wakatime_exception' INT TERM
    _wakatime_call
}


_handle_wakatime_exception() {
    # Prints out plugin information, exception body is then printed
    # via `_wakatime_call` function to stderr:
    echo "${PLUGIN_NAME}@${PLUGIN_VERSION} had an error:"
}


_wakatime_call() {
    # Running `wakatime`'s CLI in async mode:
    # shellcheck disable=SC2091
    $(wakatime --write \
        --plugin "${PLUGIN_NAME}/${PLUGIN_VERSION}" \
        --entity-type app \
        --entity "$(_last_command)" \
        --project "$(_current_directory)" \
        --language sh \
        --timeout "$WAKATIME_TIMEOUT" \
        "$(_should_work_online)" \
        >/dev/null &)
}


_should_work_online() {
    # Checks if the app should work online, otherwise returns
    # a special option to turn `wakatime` sync off:
    if [[ ! -z "$WAKATIME_DISABLE_OFFLINE" ]]; then
      echo '--disable-offline'
    else
      echo ''
    fi
}


_current_directory() {
    # We only take the `root` directory name.
    # We detect `root` directories by `.git` folder.
    # If we are not in the git repository,
    # take the default `Terminal` project.
    local root_directory
    root_directory=$(
        git rev-parse --show-toplevel 2>/dev/null || echo "Terminal"
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
