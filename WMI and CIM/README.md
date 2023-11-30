## First task

**Write a script to get from selected remote computer the following data:**

* CPU model and max clock speed
* Amount of RAM (total, free)
* OS disk free space
* OS version
* Installed hot fixes
* List of stopped services

# Solution

```$spooler = Get-WmiObject -Query "SELECT * FROM win32_service WHERE name='Spooler'"```
Creating a localhost server on Windows

Other lines looks like:
```Get-WmiObject -Class Class_You_Need -ComputerName localhost | Select-Object Your_Arguments ```

## Second task

**Write a script to get all interactive and remote logon sessions for the selected remote computer. And for every session find associated user information.**

_Hint: use classes Win32_LogonSession and Win32_Account._
