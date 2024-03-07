# utas-helper
Utas machine setup helper

## For windows Machine

### First step, allow script execution

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
```

### Initiate set-up process

```powershell
iwr -useb https://bit.ly/utas-setup-win | iex
```
