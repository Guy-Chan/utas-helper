# UTAS Helper

This repository contains scripts to facilitate operating machines in the university lab, supporting both Windows and macOS platforms.

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

The setup script for Windows automates the installation of various tools, including:
- `git`
- `fastfetch`
- `python3.12`
- `VSCode extensions`

It also configures environment variables, sets up the terminal to use oh-my-zsh, and implements Emacs keybindings. Additionally, it installs PowerToys for remapping keys, such as remapping Caps Lock as Control and Scroll Lock as Caps Lock.
