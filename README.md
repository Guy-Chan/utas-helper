# UTAS Helper

This repository contains scripts designed to streamline the setup and operation of machines in the university lab, with support for both windows and macOS.

The goal of this project is to fully harness the potential of lab machines. Since students can't always guarantee access to the same machine each time, these scripts help set up the environment quickly and efficiently.

## For Windows Machines

### Setup Process

To start the setup process on a Windows machine, open PowerShell and run the following command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process
iwr -useb https://raw.githubusercontent.com/guy-chen-codes/utas-helper/main/win-setup.ps1 | iex
```

This setup script has been tested on Windows 11 in the Launceston Lab and automates the installation and configuration of various tools, including:

- **PowerToys:** Installs PowerToys for remapping keys, such as setting Caps Lock as Control and Scroll Lock as Caps Lock. While this might initially feel uncomfortable due to muscle memory conflicts, it’s worth adapting to. I initially replaced the PowerToys configuration file directly, but updates to PowerToys can change the file location or syntax. That’s why I now use their backup/restore feature. Unfortunately, there's no CLI method to automate this, so when PowerToys starts through the script, you’ll need to manually click the "restore" button to load the configuration for the first time. My configuration also enables "awake", which bypasses the administrator setting to keep the screen active indefinitely—saving time when you're listening to tutors and don’t want to keep re-entering your password. This situation can happen more often than you’d imagine.
- **Tools:** Installs essential tools such as `jq`, `jid`, `marp` (Markdown to Slides), `gh` (GitHub CLI), `fastfetch`, `dua` (Disk Usage Analyzer), `tldr` (simplified man pages), `carnac` (for displaying keystrokes during demonstrations), `sysinternals` (`ZoomIt` for efficient demonstrations), `yt-dlp`, and `msys2` (which supports `tmux` on Windows), along with several VSCode extensions.
- **Environment Configuration:** Configures environment variables, sets up the terminal with `oh-my-zsh`, and enables Emacs keybindings by default.
- **Git Aliases:** Adds useful Git aliases such as `git st` for `git status` and `git lg` for visualizing Git logs. For a complete list, see the [Git configuration section](https://github.com/Guy-Chan/utas-helper/blob/main/win-setup.ps1#L61).

## For Mac Machines

### Setup Process

To start the setup process on a Mac machine, open Terminal and run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/guy-chen-codes/utas-helper/main/mac-setup.sh)"
source ~/.profile
```

This setup script has been tested on macOS in the Launceston lab with the following execution times:

> real: 2m32.440s  
> user: 0m32.330s  
> sys: 0m18.064s

It automates the installation and configuration of various tools, including:

- **Alias Setup:** Configures essential aliases and functions within the `~/.profile` file. This includes `utas` to quickly copy your UTAS email to the clipboard—handy in various scenarios—SSH shortcuts for commonly used lab servers, and `awake` to keep your Mac awake during long tutoring sessions.

- **Homebrew Installation:** Installs Homebrew, the de facto package manager for macOS, in a user-specific location (`~/.local/Homebrew`). The script ensures that Homebrew’s binaries are added to your PATH and configures Homebrew Cask options to install applications in the `~/Applications` directory.

- **Git Configuration:** Sets up useful Git aliases, such as `git lg` for a graphical log view and `git st` for quick status checks.

- **Zoom Installation:** Installs Zoom via Homebrew without requiring root privileges. Since Zoom is not pre-installed on the lab's Mac machines, this setup allows students to attend Zoom sessions while continuing their work in the Mac lab. This helps avoid the inconvenience of switching to a Windows machine. However, please note that screen sharing is not permitted on the lab's macOS machines due to permission restrictions.

- **iTerm2 Version Lock:** Locks iTerm2, a popular terminal emulator for macOS, to version 3.4.23, preserving this specific version against future updates. The repository includes my personal iTerm2 settings, which will be cloned into your home directory during the setup process. You can restore these settings to experience the configuration firsthand. I've increased the font size to 24 and set the opacity to 0.33 for better visualization. Additionally, I've configured the option key as the meta key, enabling the use of Bash built-in readline shortcuts for efficient command-line editing. For more details on these shortcuts, you can explore the [GNU Readline Library](https://tiswww.case.edu/php/chet/readline/rluserman.html#Commands-For-Moving). Building these shortcuts into muscle memory can enhance your CLI experience.

- **VSCode Extensions:** Installs a set of VSCode extensions tailored for development, including GitHub Copilot, Python-related tools, and remote SSH capabilities, to enhance your coding and debugging experience on macOS.

- **Utilities and Tools:** Installs a variety of useful command-line tools, such as `tlrc`, `jid`, `pandoc`, `jq`, `zip`, and `dua-cli`, to enhance productivity. These tools are essential for tasks like data processing, text formatting, and disk usage analysis.

- **VisualBoyAdvance-M:** Installs VisualBoyAdvance-M, a versatile and user-friendly Game Boy emulator. It supports a wide range of Game Boy systems (original, Color, and Advance) and features tools like save states, screen recording, and debugging functionalities. This is a handy utility for both gaming enthusiasts and developers working with retro games.

- **AltServer:** Installs AltServer, a tool for sideloading iOS apps onto your devices without jailbreaking. This utility allows you to deploy custom or third-party apps, providing flexibility for developers and advanced users to test and use apps outside the App Store ecosystem.

- **Personal Customization:** If a custom `customization` function is defined, the script will execute this function to apply additional personal preferences, ensuring your environment is tailored to your specific needs.

- **KIT718 and KIT719 Dependencies:** Installs specific dependencies required for the KIT718 and KIT719 units, such as Python packages for data science (`matplotlib`, `scikit-learn`, `pandas`, `scikit-image`) and a Sense HAT emulator for KIT719. These are commented out by default and included for demonstration purposes only, due to the execution time would be tremendous.

## Notes

- **Disclaimer**: This tool is designed for helpful and informative purposes. Please use it responsibly and ethically. Ensure you understand and comply with all relevant legal and ethical guidelines when using this tool.
