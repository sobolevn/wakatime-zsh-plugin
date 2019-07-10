# wakatime-zsh-plguin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin

_wakatime_heartbeat() {
  # Sends a heartbeat to the wakarime server before each command.
  # But it can be disabled by an environment variable:
  # Set `$WAKATIME_DO_NOT_TRACK` to non-empty value to skip the tracking.
  if [[ -n "$WAKATIME_DO_NOT_TRACK" ]]; then
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

  # We only send the last command to the wakatime.
  # We only send the first argument, which is a binary in 99% of cases.
  # It does not include any sensitive information.
  local last_command
  last_command=$(echo "$1" | cut -d ' ' -f1)

  # We only take the `root` directory name.
  # We detect `root` directories by `.git` folder.
  # If we are not in the git repository,
  # take the default `Terminal` project.
  local root_directory
  root_directory=$(
    git rev-parse --show-toplevel 2>/dev/null || echo "Terminal"
  )

  # Checks if the app should work online, otherwise returns
  # a special option to turn `wakatime` sync off:
  local should_work_online
  if [[ -n "$WAKATIME_DISABLE_OFFLINE" ]]; then
    should_work_online='--disable-offline'
  else
    should_work_online=''
  fi

  # Usage section can be found here:
  # https://github.com/wakatime/wakatime
  wakatime --write \
    --plugin "wakatime-zsh-plugin/0.1.1" \
    --entity-type app \
    --entity "$last_command" \
    --project "${root_directory:t}" \
    --language sh \
    --timeout "${WAKATIME_TIMEOUT:-5}" \
    $should_work_online \
    >/dev/null &!
  # See more about `&!`. It is `zsh` specific, link:
  # https://blog.debiania.in.ua/posts/2013-03-13-fun-with-bash-disown.html
}

# See docs on what `preexec_functions` is:
# http://zsh.sourceforge.net/Doc/Release/Functions.html
preexec_functions+=(_wakatime_heartbeat)
