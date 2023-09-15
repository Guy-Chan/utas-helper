if (-not(Test-Path $PROFILE)) { mkdir "$PROFILE/.." -Force }

# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
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
# set-alias v vagrant
# set-alias vbm vboxmanage
# set-alias k kubectl
function misc() { cd "$env:utas_repos/utas-misc" }
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

$USER_GUY = 'ychen99'
# allow policy
if (-not(Test-Path $env:scoop)) {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
    iwr -useb get.scoop.sh | iex
}

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
# there are issues with powertoys per user 
# in terms of detecting dotnet runtime installed machine wide,
# fix the version to 0.68.1 as the work around
git -C "$env:scoop\buckets\extras" co 3e7eb49
scoop install -u powertoys@0.68.1
git -C "$env:scoop\buckets\extras" co master
scoop install firefox
scoop install potplayer
scoop install gh
scoop install clash
scoop install zoom
scoop install snipaste
scoop install logseq
scoop install zettlr
scoop install calibre-normal
scoop install aria-ng-gui
scoop install carnac
scoop install sysinternals
scoop install yt-dlp
scoop install neofetch
scoop install audioswitcher
# scoop install aws
scoop install winget
scoop install oh-my-posh
scoop install CascadiaCode-NF-Mono
scoop install tealdeer
scoop install zip
tldr --update
if (-not(Test-Path ~/repos)) { mkdir ~/repos/utas -Force }
git clone https://github.com/Guy-Chan/utas-helper.git "$env:repos/utas-helper"
$wt_settings_path = $(ls "${env:LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json" | Select-Object -Property FullName).FullName
cp "$env:repos/utas-helper/wt-setting.json" "$wt_settings_path"
echo 'oh-my-posh init pwsh | Invoke-Expression' | ac $PROFILE
. $PROFILE
    
# scoop install vagrant
# scoop install vboxvmservice
# scoop install kubectl
# scoop install virtualbox-np

# scoop install azure-cli
# winget install Microsoft.AzureCLI
gh auth login
gh repo clone Guy-Chan/utas-helper "$env:repos/utas-helper"
mkdir ~/repos/utas -Force
if ($(whoami) -eq "$USER_GUY") {
    # personal setup, containing some credentials
    gh repo clone Guy-Chan/utas-personal "$env:repos/utas-personal"
    . "$env:repos/utas-personal/utas-win-setup.ps1"
}

# ssh -p 8022 10.
