# wakatime-zsh-plugin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin

_wakatime_heartbeat() {
  # Sends a heartbeat to the wakatime server before each command.
  # But it can be disabled by an environment variable:
  # Set `$WAKATIME_DO_NOT_TRACK` to 1 to skip the tracking.
  if (( WAKATIME_DO_NOT_TRACK )); then
    return  # Tracking is skipped!
  fi

  # Checks if `wakatime` is installed,
  # syntax is `zsh` specific, see: https://unix.stackexchange.com/a/237084
  if (( ! $+commands[wakatime] )); then
    echo 'wakatime cli is not installed, run:'
    echo '$ pip install wakatime'
    echo 'Or check that wakatime is in PATH'
    echo
    echo 'Time is not tracked for now.'
    return
  fi

  # We only send the last command to the wakatime.
  # We only send the first argument, which is a binary in 99% of cases.
  # It does not include any sensitive information.
  local last_command
  last_command=$(echo "$history[$HISTCMD]" | cut -d ' ' -f1)

  # Determine the project name
  local root_directory

  # If the `.wakatime-project` file exists
  # then we read the first line to get the project name
  # and use it as the `root` directory name.
  if [ -f .wakatime-project ]; then
    read -r root_directory < .wakatime-project
  fi

  # If the `.wakatime-project` file does not exist (or if it is empty)
  # then we get the `root` directory from the current git repository.
  # If we are not in a git repository
  # then we will use the default project name `Terminal`.
  if [ -z "$root_directory" ]; then
    root_directory=$(
      git rev-parse --show-toplevel 2>/dev/null || echo 'Terminal'
    )
  fi

  # Checks if the app should work online, otherwise returns
  # a special option to turn `wakatime` sync off:
  local should_work_online
  if (( WAKATIME_DISABLE_OFFLINE )); then
    should_work_online='--disable-offline'
  else
    should_work_online=''
  fi

  wakatime --write \
    --plugin 'wakatime-zsh-plugin/0.2.1' \
    --entity-type app \
    --entity "$last_command" \
    --project "${root_directory:t}" \
    --language sh \
    --timeout "${WAKATIME_TIMEOUT:-5}" \
    $should_work_online \
    &>/dev/null </dev/null &!
}

# See docs on `add-zsh-hook`:
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/add-zsh-hook
autoload -U add-zsh-hook

# See docs on what `preexec` is:
# http://zsh.sourceforge.net/Doc/Release/Functions.html
add-zsh-hook preexec _wakatime_heartbeat
