# Changelog


## Version 0.2.2

### Improvements

- Allows custom wakatime-cli path via ZSH_WAKATIME_BIN environment variable.

## Version 0.2.0

### Improvements

- Addresses review from Reddit: removes useless functions, improves performance

### Bugfixes

- Fixes how `should_work_offline` work


## Version 0.1.1

### Improvements

- Linting fixes


## Version 0.1.0

### Improvements

- Bumps `wakatime` to `12.0`
- Adds `$WAKATIME_TIMEOUT` option
- Adds `$WAKATIME_DISABLE_OFFLINE` option

### Bugfixes

- Now exceptions from `wakatime` are visible in the console


## Version 0.0.2

### Improvements

- Now calls to `wakatime` server are async
- If `wakatime` cli is not installed, plugin will tell users about it

### Bugfixes

- Fixed the bug with `$WAKATIME_DO_NOT_TRACK` killing the shell


## Version 0.0.1

- Initial release
