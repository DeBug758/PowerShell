$spooler = Get-WmiObject -Query "SELECT * FROM win32_service WHERE name='Spooler'"
$spooler.StopService()
$spooler.StartService()
Get-WmiObject -Class Win32_Processor -ComputerName localhost | Select-Object Name, MaxClockSpeed, Caption, Version
Get-WmiObject -Class Win32_OperatingSystem -ComputerName localhost | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
Get-WmiObject -Class Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='C:'"| Select-Object FreeSpace
Get-HotFix -ComputerName localhost
Get-Service -ComputerName localhost | Where-Object {$_.Status -eq "Stopped"}
$spooler.StopService()
