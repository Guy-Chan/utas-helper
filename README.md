# UTAS Helper

This repository contains scripts designed to streamline the operation of machines within the university lab, with support for both Windows and macOS platforms.

## For Windows Machines

### Prerequisites

Before running the setup script, ensure that script execution is enabled:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
```

### Setup Process

Initiate the setup process by running the following command in PowerShell:

```
iwr -useb https://bit.ly/utas-setup-win | iex
```

The Windows setup script automates the installation of various tools, including:
- `jid`
- `gh`
- `fastfetch`
- `dua`
- `tldr`
- `python3.12`
- `VSCode extensions`

It also configures environment variables, sets up the terminal to use oh-my-zsh, and implements Emacs keybindings. Additionally, it adds useful git aliases such as `git st` for `git status` and `git lg` for checking git logs. For detailed configurations, refer to [git configs](https://github.com/Guy-Chan/utas-helper/blob/ddd7497467071df4573d35bc2338dae21a6d5818/win-setup.ps1#L87). Furthermore, it installs PowerToys for remapping keys, such as Caps Lock as Control and Scroll Lock as Caps Lock.
