function Delete-FileBySize{
	<#
	.SYNOPSIS
		Deletes file by specific size
	.DESCRIPTION
		Deletes file from a specific folder if file size greater then specified size in Kb.
	.EXAMPLE
		PS C:\> Get-ChildItem -Path <PATH> -File | Select-Object FullName | ForEach-Object {$_.FullName} | Delete-FileBySize
        PS C:\> Delete-FileBySize -pth <PATH> -size 8
	.INPUTS
		Input
	.OUTPUTS
		Output
	.NOTES
		General notes
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		#[ValidateNotNullOrEmpty]
		[string]$pth,
		
		[Parameter(Mandatory = $false, ValueFromPipeline = $false)]
		[int]$size = 0
	)
	process{
		$len = Get-ChildItem -Path $pth | Select-Object Length 
		if($len.Length -ge ($size * 1024)){
			Remove-Item $pth
		}
	}
}
