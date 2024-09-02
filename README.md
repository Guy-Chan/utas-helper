# UTAS Helper

This repository contains scripts designed to streamline the setup and operation of machines in the university lab, with initial support for Windows platforms. macOS support will be added soon.

The goal of this project is to fully harness the potential of lab machines. Since students can't always guarantee access to the same machine each time, these scripts help set up the environment quickly and efficiently.

## For Windows Machines

### Setup Process

To start the setup process on a Windows machine, open PowerShell and run the following command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process
iwr -useb https://bit.ly/utas-setup-win | iex
```

This setup script has been tested on Windows 11 in the Launceston Lab and automates the installation and configuration of various tools, including:

- **PowerToys:** Installs PowerToys for remapping keys, such as setting Caps Lock as Control and Scroll Lock as Caps Lock. While this might initially feel uncomfortable due to muscle memory conflicts, it’s worth adapting to. I initially replaced the PowerToys configuration file directly, but updates to PowerToys can change the file location or syntax. That’s why I now use their backup/restore feature. Unfortunately, there's no CLI method to automate this, so when PowerToys starts through the script, you’ll need to manually click the "restore" button to load the configuration for the first time. My configuration also enables "awake", which bypasses the administrator setting to keep the screen active indefinitely—saving time when you're listening to tutors and don’t want to keep re-entering your password. This situation can happen more often than you’d imagine.
- **Tools:** Installs essential tools such as `jq`, `jid`, `marp` (Markdown to Slides), `gh` (GitHub CLI), `fastfetch`, `dua` (Disk Usage Analyzer), `tldr` (simplified man pages), `carnac` (for displaying keystrokes during demonstrations), `sysinternals` (`ZoomIt` for efficient demonstrations), `yt-dlp`, and `msys2` (which supports `tmux` on Windows), along with several VSCode extensions.
- **Environment Configuration:** Configures environment variables, sets up the terminal with `oh-my-zsh`, and enables Emacs keybindings by default.
- **Git Aliases:** Adds useful Git aliases such as `git st` for `git status` and `git lg` for visualizing Git logs. For a complete list, see the [Git configuration section](https://github.com/Guy-Chan/utas-helper/blob/main/win-setup.ps1#L89).

### Notes

- **Mac Setup:** A macOS setup script will be added in the future. The delay is due to the need to separate personal credentials from the general configuration.

- **Disclaimer**: This tool is designed for helpful and informative purposes. Please use it responsibly and ethically. Ensure you understand and comply with all relevant legal and ethical guidelines when using this tool.
