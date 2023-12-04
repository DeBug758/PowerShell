if ($args.Count -ne 3) {
    Write-Host -ForegroundColor Red "Error: This script requires exactly 3 parameters."
    exit
}

if ($args[0] -match "^(\d{1,3}\.){3}\d{1,3}$"){ # Cheks if format x.x.x.x
	[System.Net.IPAddress]$network_mask = $args[0]
	if ($? -eq $false){
		exit
	}
}

if ($args[1] -match "^(\d{1,3}\.){3}\d{1,3}$"){ # Cheks if format x.x.x.x
	[System.Net.IPAddress]$network_mask = $args[1]
	if ($? -eq $false){
		exit
	}
}

if ($args[2] -match "^(\d{1,3}\.){3}\d{1,3}$"){ # Cheks if format x.x.x.x
	[System.Net.IPAddress]$network_mask = $args[2]
	if ($? -eq $false){
		exit
	}
}
else{ # If mask in format of xx
	if(($args[2] -gt 32) -or ($args[2] -lt 0)){
		Write-Host -ForegroundColor Red "Error: 3rd argument is not valid (0 <= [int] <= 32 is required or in the format x.x.x.x)"
		exit
	}
	elseif($args[2] -ge 24){ # If $args[2] -ge 24 mask is 11111111.11111111.11111111.?
		$subnetMaskBinary[0] = 255
		$subnetMaskBinary[1] = 255
		$subnetMaskBinary[2] = 255
		$s = "" # Here I store ? part of mask
		for($i = 0; $i -lt $args[2] - 24; $i++){ # Number of 1 is eq $args[2] - 24
			$s += '1'
		} #Example: Now my $s = "111"
		for($i = $args[2]; $i -lt 32; $i++){ 
			$s += '0' # Here I adding remaining 0
		} #Example: $s = "11100000" 
		$subnetMaskBinary[3] = [Convert]::ToInt32($s, 2)
	}
	elseif($args[2] -ge 16){ # If $args[2] -ge 16 mask is 11111111.11111111.?.0
		$subnetMaskBinary[0] = 255
		$subnetMaskBinary[1] = 255
		$s = ""
		for($i = 0; $i -lt $args[2] - 16; $i++){
			$s += '1'
		}
		for($i = $args[2]; $i -lt 24; $i++){
			$s += '0'
		}
		$subnetMaskBinary[2] = [Convert]::ToInt32($s, 2)
		$subnetMaskBinary[3] = 0
	}
	elseif($args[2] -ge 8){ # If $args[2] -ge 8 mask is 11111111.?.0.0
		$subnetMaskBinary[0] = 255
		$s = ""
		for($i = 0; $i -lt $args[2] - 8; $i++){
			$s += '1'
		}
		for($i = $args[2]; $i -lt 16; $i++){
			$s += '0'
		}
		$subnetMaskBinary[1] = [Convert]::ToInt32($s, 2)
		$subnetMaskBinary[2] = 0
		$subnetMaskBinary[3] = 0
	}
	else{ # Mask is ?.0.0.0
		$s = ""
		for($i = 0; $i -lt $args[2] - 0; $i++){
			$s += '1'
		}
		for($i = $args[2]; $i -lt 8; $i++){
			$s += '0'
		}
		$subnetMaskBinary[0] = [Convert]::ToInt32($s, 2)
		$subnetMaskBinary[1] = 0
		$subnetMaskBinary[2] = 0
		$subnetMaskBinary[3] = 0
	}
}

$ip1Binary = $ip_address_1.GetAddressBytes() # Spliting ip_addresses
$ip2Binary = $ip_address_2.GetAddressBytes()

$ip1Subnet = [byte[]]::new(4)
$ip2Subnet = [byte[]]::new(4)

for ($i = 0; $i -lt 4; $i++) { # Calculating part
    $ip1Subnet[$i] = $ip1Binary[$i] -band $subnetMaskBinary[$i] # Logical and between $i octet
    $ip2Subnet[$i] = $ip2Binary[$i] -band $subnetMaskBinary[$i]
}
$res1 = $ip1Subnet -join "."
$res2 = $ip2Subnet -join "."
if ($res1 -eq $res2) {
    Write-Host "yes"
} else {
    Write-Host "no"
}
