# wakatime-zsh-plugin

[![wemake.services](https://img.shields.io/badge/style-wemake.services-green.svg?label=&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC%2FxhBQAAAAFzUkdCAK7OHOkAAAAbUExURQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP%2F%2F%2F5TvxDIAAAAIdFJOUwAjRA8xXANAL%2Bv0SAAAADNJREFUGNNjYCAIOJjRBdBFWMkVQeGzcHAwksJnAPPZGOGAASzPzAEHEGVsLExQwE7YswCb7AFZSF3bbAAAAABJRU5ErkJggg%3D%3D)](http://wemake.services) [![Build Status](https://img.shields.io/travis/sobolevn/wakatime-zsh-plugin/master.svg)](https://travis-ci.org/sobolevn/wakatime-zsh-plugin) [![GitHub Release](https://img.shields.io/badge/release-0.0.2-brightgreen.svg?style=default)](https://github.com/sobolevn/wakatime-zsh-plugin/releases)


## What does this plugin do?

This plugin provides `zsh` and `wakatime` integration. In other words, it tracks all time you spend in a terminal. Unlike other plugins, this one tries to keep all your spent time in the same `wakatime`'s project.


## Installation

Before we start you will need to run:

```bash
pip install wakatime
```

This command will install [Wakatime's CLI](https://github.com/wakatime/wakatime).

### antigen

If you're using [`antigen`](https://github.com/zsh-users/antigen), you can install this plugin with `antigen bundle sobolevn/wakatime-zsh-plugin`.

### zgen

If you're using `zgen`, add this plugin to your `init.zsh` with `zgen load sobolevn/wakatime-zsh-plugin`.

### Manual

Just copy the [`wakatime.plugin.zsh`](/wakatime.plugin.zsh) to your `~/.oh-my-zsh/custom/plugins/` folder.

This set of commands will probably do what you want:

```shell
git clone https://github.com/sobolevn/wakatime-zsh-plugin.git
ln -s $PWD/wakatime-zsh-plugin/wakatime.plugin.zsh ~/.oh-my-zsh/custom/plugins/wakatime.plugin.zsh
```

Then set `wakatime` to [the plugins list](https://github.com/robbyrussell/oh-my-zsh/wiki/External-plugins) inside your `.zshrc`.


## Configuration

Wakatime supports configuration via [`~/.wakatime.cfg`](https://github.com/wakatime/wakatime#configuring). You will need to set your `api_key`.

You can also disable tracking for some period of time by setting `$WAKATIME_DO_NOT_TRACK` environment variable to any non-empty value.


## Alternatives

There are several alternatives to this project:

1. [`zsh-wakatime`](https://github.com/wbingli/zsh-wakatime/blob/master/zsh-wakatime.plugin.zsh)
2. [`bash-wakatime`](https://github.com/gjsheep/bash-wakatime)
3. [`fish-wakatime`](https://github.com/Cyber-Duck/fish-wakatime)

See the full list [here](https://wakatime.com/terminal).


## License

MIT. See [LICENSE.md](https://github.com/sobolevn/wakatime-zsh-plugin/blob/master/LICENSE.md) for more details.
