$ErrorActionPreference = 'SilentlyContinue'

# Ensure the PowerShell profile directory exists
if (-not (Test-Path $PROFILE)) { 
    mkdir (Split-Path -Parent $PROFILE) -Force 
}

# Remove existing profile and create a new one
Remove-Item $PROFILE -Force
@'
# Set environment variables and aliases
Set-PSReadLineOption -EditMode Emacs
$env:scoop = "$env:USERPROFILE\scoop"
$env:repos = "$env:USERPROFILE/repos"
$env:utas_repos = "$env:repos/utas"
$env:path = ";$env:scoop\apps\git\current\mingw64\bin"`
+ ";$env:scoop\apps\git\current\usr\bin"`
+ ";$env:scoop\shims"`
+ ";$env:path"

Set-Alias wl-copy Set-Clipboard
# Set-Alias v vagrant
# Set-Alias vbm vboxmanage
# Set-Alias k kubectl

# Functions for convenience
function helper { cd "$env:repos/utas-helper" }
function misc { cd "$env:utas_repos/utas-misc" }
function utas { & "$env:ComSpec/../whoami*" /upn | wl-copy }
function ict { ssh "$env:USERNAME@ictteach.its.utas.edu.au" }
function tracker { echo 'https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt' | wl-copy }
function jetbrains { 
    winget install 'JetBrains.IntelliJIDEA.Ultimate'
    winget install 'JetBrains.PyCharm.Professional'
}

function sync($git_dir) {
    echo "Start syncing the repo located at ${git_dir}."
    git -C "$git_dir" fetch origin
    git -C "$git_dir" pull
    git -C "$git_dir" add -A
    git -C "$git_dir" commit -m 'sync'
    git -C "$git_dir" push
    echo "Finished syncing the repo located at ${git_dir}."
}
'@ | Add-Content $PROFILE

. $PROFILE

# Configure VS Code if not already set
$cmdlet = Get-Command -Name "code" -ErrorAction SilentlyContinue
if (-not $cmdlet) {
    @'
# Add VS Code to PATH
$env:path = ";$env:ProgramFiles\Microsoft VS Code\bin"`
+ ";$env:path"
'@ | Add-Content $PROFILE
    . $PROFILE
}

# Scoop and additional setups
$USER_GUY = 'ychen99'
if (-not (Test-Path $env:scoop)) {
    iwr -useb get.scoop.sh | iex
}

function optional_scoop_install {
    # Scoop installations
    scoop bucket add games
    scoop install steam snipaste logseq calibre-normal aria-ng-gui firefox opera potplayer clash
    start -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\Snipaste.lnk" -WindowStyle Hidden
}

function code_extensions_install {
    code --install-extension ms-vscode.powershell
    code --install-extension GitHub.copilot
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension KevinRose.vsc-python-indent
    code --install-extension charliermarsh.ruff
}

# Install Visual Studio Code extensions
code_extensions_install

# Install and configure Git
scoop install git
git config --global alias.fu 'fetch upstream'
git config --global alias.fo 'fetch origin'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cm commit
git config --global alias.st status
git config --global alias.cp cherry-pick
git config --global alias.po 'push -u origin HEAD'
git config --global alias.cl 'clean -d -f'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global push.default current
git config --global remote.pushDefault origin
git config --global pull.rebase false

# Additional scoop setups
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install aria2
scoop config aria2-warning-enabled false
scoop install powertoys
git clone https://github.com/Guy-Chan/utas-helper.git "$env:repos/utas-helper"

scoop install jq jid marp zip pandoc carnac sysinternals yt-dlp msys2 fastfetch dua oh-my-posh CascadiaCode-NF-Mono

# Restore PowerToys settings
$ptb="~\Documents\PowerToys\Backup\*ptb"
if (-not (Test-Path $ptb)) {
    mkdir (Split-Path -Parent $ptb) -Force
    Copy-Item "$env:repos\utas-helper\*ptb" (Split-Path -Parent $ptb) -Force
}

# Restore msys2 profile
Copy-Item "$env:repos\utas-helper\msys2-profile" "$env:scoop\apps\msys2\current\home\$($env:USERNAME)\.profile" -Force

# Restart PowerToys
Get-Process PowerToys -ErrorAction SilentlyContinue | Stop-Process
Start-Process -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\PowerToys.lnk" -WindowStyle Hidden

# Initialize oh-my-posh
echo 'oh-my-posh init pwsh | Invoke-Expression' | Add-Content $PROFILE

# Restore Windows Terminal settings
$wt_settings_path = (Get-ChildItem -Path "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json").FullName
Copy-Item "$env:repos/utas-helper/wt-setting.json" "$wt_settings_path" -Force

$wt_state_path = (Get-ChildItem -Path "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/state.json").FullName
$json = Get-Content -Path "$wt_state_path" | ConvertFrom-Json
if (-not ($json.PSObject.Properties.Name -contains "dismissedMessages")) {
    $json | Add-Member -Type NoteProperty -Name "dismissedMessages" -Value @("setAsDefault")
}
$json | ConvertTo-Json | Set-Content "$wt_state_path"

# Install additional tools
scoop install zoom

if ((whoami) -eq $USER_GUY) {
    scoop install gh
    gh auth login
    mkdir "$env:repos/utas" -Force
    gh repo clone Guy-Chan/utas-personal "$env:repos/utas-personal"
    . "$env:repos/utas-personal/utas-win-setup.ps1"
    optional_scoop_install
}

# Restart Windows Terminal
$currentProcess = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Select-Object -First 1
Start-Process wt
Stop-Process -Id $currentProcess.Id
