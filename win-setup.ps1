$ErrorActionPreference = 'silentlycontinue'
if (-not(Test-Path $PROFILE)) { mkdir "$PROFILE/.." -Force }

rm $PROFILE -Force
echo @'
# set env
Set-PSReadLineOption -EditMode Emacs
$env:scoop = "$env:USERPROFILE\scoop"
$env:repos = "$env:USERPROFILE/repos"
$env:utas_repos = "$env:repos/utas"
$env:path = ";$env:scoop\apps\git\current\mingw64\bin"`
+ ";$env:scoop\apps\git\current\usr\bin"`
+ ";$env:scoop\shims"`
+ ";$env:path"

set-alias wl-copy set-clipboard

function helper() { cd "$env:repos/utas-helper" }
function misc() { cd "$env:utas_repos/utas-misc" }
function utas() { ."$env:ComSpec/../whoami*" /upn | wl-copy }
function ict() { ssh "$env:USERNAME@ictteach.its.utas.edu.au" }
function tracker() { echo 'https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt' | wl-copy }
function jetbrains() { 
    winget install 'JetBrains.IntelliJIDEA.Ultimate'
    winget install 'JetBrains.PyCharm.Professional'
}

function sync($git_dir){
    echo "start sync the repo located at ${git_dir} ."
    git -C "$git_dir" fo
    git -C "$git_dir" pull
    git -C "$git_dir" add -A
    git -C "$git_dir" ci -m 'sync'
    git -C "$git_dir" po
    echo "end sync the repo located at ${git_dir} ."
}
'@ | ac $PROFILE
. $PROFILE

$ErrorActionPreference = 'SilentlyContinue'
$cmdlet = Get-Command -Name "code" -ErrorAction SilentlyContinue
if ($cmdlet -eq $null) {
    echo @'
# add vscode to env
$env:path = ";$env:ProgramFiles\Microsoft VS Code\bin"`
+ ";$env:path"
'@ | ac $PROFILE
    . $PROFILE
}

# allow policy
if (-not(Test-Path $env:scoop)) {
    iwr -useb get.scoop.sh | iex
}

function code_extensions_install() {
    code --install-extension ms-vscode.powershell
    code --install-extension GitHub.copilot
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension KevinRose.vsc-python-indent
    code --install-extension charliermarsh.ruff
}

code_extensions_install

scoop install git
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

scoop install jq jid marp zip pandoc carnac sysinternals yt-dlp msys2 fastfetch dua
scoop install oh-my-posh CascadiaCode-NF-Mono 
scoop install zoom

# cp the backup PT settings  
$ptb="~\Documents\PowerToys\Backup\*ptb"
if (-not(Test-Path $ptb)) { 
    mkdir "$ptb/.." -Force 
    cp "$env:repos\utas-helper\*ptb" "$ptb/.."
}

# restore msys2 .profile
cp "$env:repos\utas-helper\msys2-profile" "$env:scoop\apps\msys2\current\home\$(whoami)\.profile" 
  
# Terminate the PowerToys process  
Get-Process PowerToys -ErrorAction SilentlyContinue | Stop-Process  
  
# Start PowerToys  
start -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\PowerToys.lnk" -WindowStyle Hidden  

echo 'oh-my-posh init pwsh | Invoke-Expression' | ac $PROFILE

# restore wt settings.json
$wt_settings_path = $(ls "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json" | Select-Object -Property FullName).FullName
cp "$env:repos/utas-helper/wt-setting.json" "$wt_settings_path"

# restore wt state.json
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

# reload WindowsTerminal
# Get the current WindowsTerminal process  
$currentProcess = Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Select-Object -First 1  
  
# Start a new WindowsTerminal process  
Start-Process wt  
  
# Stop the current WindowsTerminal process  
exit
