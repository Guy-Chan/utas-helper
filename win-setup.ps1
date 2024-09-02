$ErrorActionPreference = 'SilentlyContinue'
# Ensure the PowerShell profile directory exists
if (-not (Test-Path $PROFILE)) { 
    mkdir "$PROFILE/.." -Force
}

# Remove existing profile and create a new one
Remove-Item $PROFILE -Force
echo @'
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

# Functions for convenience
function helper() { cd "$env:repos/utas-helper" }
function utas() { ."$env:ComSpec/../whoami*" /upn | wl-copy } # set utas email to the clipboard, can be quite handy sometimes
function 501() { ssh "$env:USERNAME@ictteach.its.utas.edu.au" } # ssh to KIT501 lab server
function 502() { ssh "$env:USERNAME@ictteach-www.its.utas.edu.au" } # ssh to KIT502 lab server
'@ | ac $PROFILE
. $PROFILE

# Configure VS Code if not already set
$cmdlet = Get-Command -Name "code" -ErrorAction SilentlyContinue
if (-not $cmdlet) {
    echo @'
# Add VS Code to PATH
$env:path = ";$env:ProgramFiles\Microsoft VS Code\bin"`
+ ";$env:path"
'@ | ac $PROFILE
    . $PROFILE
}

# Install Visual Studio Code extensions
function code_extensions_install {
    code --install-extension ms-vscode.powershell
    code --install-extension GitHub.copilot
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension KevinRose.vsc-python-indent
    code --install-extension charliermarsh.ruff
}

code_extensions_install

# Scoop and additional setups
if (-not(Test-Path $env:scoop)) {
    iwr -useb get.scoop.sh | iex
}

# Install and configure Git
scoop install 7zip@23.01 git # The latest 7zip installed via scoop is broken, fix the version here as a workaround
git config --global alias.fu 'fetch upstream'
git config --global alias.fo 'fetch origin'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cm commit
git config --global alias.st status
git config --global alias.cp cherry-pick
git config --global alias.po "push -u origin HEAD"
git config --global alias.cl "clean -d -f"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global push.default current
git config --global remote.pushDefault origin
git config --global pull.rebase false

scoop bucket add extras
scoop bucket add nerd-fonts
scoop install aria2
scoop config aria2-warning-enabled false

scoop install powertoys
git clone https://github.com/Guy-Chan/utas-helper.git "$env:repos/utas-helper"

scoop install jq jid marp zip pandoc carnac sysinternals yt-dlp msys2 fastfetch dua oh-my-posh CascadiaCode-NF-Mono zoom

# Restore PowerToys settings
$ptb="~\Documents\PowerToys\Backup\*ptb"
if (-not (Test-Path $ptb)) { 
    mkdir "$ptb/.." -Force 
    cp "$env:repos\utas-helper\*ptb" "$ptb/.."
}

# Restore msys2 profile
cp "$env:repos\utas-helper\msys2-profile" "$env:scoop\apps\msys2\current\home\$(whoami)\.profile" 
  
# Restart PowerToys
Get-Process PowerToys -ErrorAction SilentlyContinue | Stop-Process  
start -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\PowerToys.lnk" -WindowStyle Hidden  

# Initialize oh-my-posh
echo 'oh-my-posh init pwsh | Invoke-Expression' | ac $PROFILE

# Restore Windows Terminal settings
$wt_settings_path = $(ls "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json" | Select-Object -Property FullName).FullName
cp "$env:repos/utas-helper/wt-setting.json" "$wt_settings_path"

$wt_state_path = $(ls "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/state.json" | Select-Object -Property FullName).FullName
$json = Get-Content -Path "$wt_state_path" | ConvertFrom-Json  
# Check if the dismissedMessages property already exists  
if (-not ($json.PSObject.Properties.Name -contains "dismissedMessages")) {  
    # If it doesn't exist, add the dismissedMessages property  
    $json | Add-Member -Type NoteProperty -Name "dismissedMessages" -Value @("setAsDefault")  
}  
# Save the modified JSON content  
$json | ConvertTo-Json | Set-Content "$wt_state_path"

# Personal setup, requires $gh_token to be set beforehand.
if ($gh_token) {
    scoop install gh
    echo $gh_token | gh auth login --with-token
    customization
}

# Restart Windows Terminal
$currentProcess = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Select-Object -First 1  
Start-Process wt  
exit
