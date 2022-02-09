# wakatime-zsh-plugin
#
# Documentation is available at:
# https://github.com/sobolevn/wakatime-zsh-plugin
#

# Check if there is a wakatime configuration file present
# Needs $WAKATIME_CHECK_CONFIG to be set to 1
# Default Is False
check_file() {
	local wakatime_home="${WAKATIME_HOME:=$HOME}"
	[ ! -f "$wakatime_home"/.wakatime.cfg ] || {
		return
	}
	echo 'No configuration file for Wakatime found'
	echo -n 'Please enter your API key => '
	read -r api_key
	[ ! -z "$api_key" ] || {
		echo 'Invalid API key provided, exiting!'
		exit 1
	}
  cat << EOF > "$wakatime_home"/.wakatime.cfg
[settings]
api_key = $api_key
EOF

}


_wakatime_heartbeat() {
  # Sends a heartbeat to the wakatime server before each command.
  # But it can be disabled by an environment variable:
  # Set `$WAKATIME_DO_NOT_TRACK` to 1 to skip the tracking.
  if (( WAKATIME_DO_NOT_TRACK )); then
    return  # Tracking is skipped!
  fi

  # Set a custom path for the wakatime-cli binary
  # otherwise point to the default `wakatime`
  local wakatime_bin="${ZSH_WAKATIME_BIN:=wakatime}"

  # Checks if `wakatime` is installed,
  if ! wakatime_loc="$(type -p "$wakatime_bin")"; then
    echo 'wakatime cli is not installed, run:'
    echo '$ pip install wakatime'
    echo
    echo 'OR:'
    echo 'Option 1: Check that wakatime is in PATH'
    echo 'Option 2: Set a custom path with $ export ZSH_WAKATIME_BIN=/path/to/wakatime-cli'
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

  "$wakatime_bin" --write \
    --plugin 'wakatime-zsh-plugin/0.2.2' \
    --entity-type app \
    --entity "$last_command" \
    --project "${root_directory:t}" \
    --language sh \
    --timeout "${WAKATIME_TIMEOUT:-5}" \
    $should_work_online \
    &>/dev/null </dev/null &!
}

if (( WAKATIME_CHECK_CONFIG )); then 
	check_file
}

# See docs on `add-zsh-hook`:
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/add-zsh-hook
autoload -U add-zsh-hook

# See docs on what `preexec` is:
# http://zsh.sourceforge.net/Doc/Release/Functions.html
add-zsh-hook preexec _wakatime_heartbeat
