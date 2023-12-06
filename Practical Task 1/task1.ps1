param(
	[Parameter()]
	[ValidatePattern("^(\d{1,3}\.){3}\d{1,3}$")]
	[string]$ip_address_1,
	
	[Parameter()]
	[ValidatePattern("^(\d{1,3}\.){3}\d{1,3}$")]
	[string]$ip_address_2,
	
	[Parameter()]
	[string]$network_mask
)
$flag = $false
if(($ip_address_1 -eq $null) -or ($ip_address_2 -eq $null) -or ($network_mask -eq $null)){
	Write-Error "One of the arguments is empty"
	exit 1
}	
if ($network_mask -match "^(\d{1,3}\.){3}\d{1,3}$"){ # Cheks if format x.x.x.x
	[System.Net.IPAddress]$network_mask_ip = $network_mask
	if ($? -eq $false){
		exit 1
	}
	$subnetMaskBinary = $network_mask_ip.GetAddressBytes()
}
else{ # If mask in format of xx
	if(!($network_mask -match "^\d{1,2}")){
		Write-Error "Error: 3rd argument is not valid (0 <= [int] <= 32 is required or in the format x.x.x.x)"
		exit 1
	}
	if(([int]$network_mask -gt 32) -or ([int]$network_mask -lt 0)){
		Write-Error "Error: 3rd argument is not valid (0 <= [int] <= 32 is required or in the format x.x.x.x)"
		exit 1
	}
	elseif([int]$network_mask -ge 24){ # If $args[2] -ge 24 mask is 11111111.11111111.11111111.?
		$s = "" # Here I store ? part of mask
		for($i = 0; $i -lt [int]$network_mask - 24; $i++){ # Number of 1 is eq $args[2] - 24
			$s += '1'
		} #Example: Now my $s = "111"
		for($i = [int]$network_mask; $i -lt 32; $i++){ 
			$s += '0' # Here I adding remaining 0
		} #Example: $s = "11100000" 
		$subnetMaskBinary = @(255, 255, 255, [Convert]::ToInt32($s, 2))
	}
	elseif([int]$network_mask -ge 16){ # If $args[2] -ge 16 mask is 11111111.11111111.?.0
		$s = ""
		for($i = 0; $i -lt [int]$network_mask - 16; $i++){
			$s += '1'
		}
		for($i = [int]$network_mask; $i -lt 24; $i++){
			$s += '0'
		}
		$subnetMaskBinary = @(255, 255, [Convert]::ToInt32($s, 2), 0)
	}
	elseif([int]$network_mask -ge 8){ # If $args[2] -ge 8 mask is 11111111.?.0.0
		$s = ""
		for($i = 0; $i -lt [int]$network_mask - 8; $i++){
			$s += '1'
		}
		for($i = [int]$network_mask; $i -lt 16; $i++){
			$s += '0'
		}
		$subnetMaskBinary = @(255, [Convert]::ToInt32($s, 2), 0, 0)
	}
	else{ # Mask is ?.0.0.0
		$s = ""
		for($i = 0; $i -lt [int]$network_mask - 0; $i++){
			$s += '1'
		}
		for($i = [int]$network_mask; $i -lt 8; $i++){
			$s += '0'
		}
		$subnetMaskBinary = @([Convert]::ToInt32($s, 2), 0, 0, 0)
	}
}

[System.Net.IPAddress]$ip1 = $ip_address_1
if($? -eq $false){
	exit 1
}
[System.Net.IPAddress]$ip2 = $ip_address_2
if($? -eq $false){
	exit 1
}
$ip1Binary = $ip1.GetAddressBytes() # Spliting ip_addresses
$ip2Binary = $ip2.GetAddressBytes()


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
    Write-Host 'no'
}
