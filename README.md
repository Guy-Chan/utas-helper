# utas-helper
Utas machine setup helper

## allow script execution

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
```

## init helper

```powershell
iwr -useb https://raw.githubusercontent.com/Guy-Chan/utas-helper/main/win-setup.ps1 | iex
```
