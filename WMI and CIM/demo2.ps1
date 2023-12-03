$spooler = Get-WmiObject -Query "SELECT * FROM win32_service WHERE name='Spooler'"

$spooler.StartService()
$sessions = Get-WmiObject -Class Win32_LogonSession -ComputerName localhost
foreach($session in $sessions){
	$sessionId = $session.LogonId
	
	$user = Get-WmiObject -Class Win32_Account | Where-Object {$_.SID -match ".*-$sessionId$"} | Select-Object -Property Name
	if ($session.LogonType -eq 2) {
        $logonType = "Interactive"
    } elseif ($session.LogonType -eq 10) {
        $logonType = "Remote"
    } else {
        $logonType = "Unknown"
    }
	
	Write-Host "Session ID: $sessionId"
    Write-Host "Logon Type: $logonType"
    Write-Host "User: $($user.Name)"
    Write-Host "Domain: $($user.Domain)"
    Write-Host ""
}
$spooler.StopService()
