function Get-ValueFromPipe{
	<#
	.SYNOPSIS
		Show the size of files
	.DESCRIPTION
		Show the size of files in specific folder and sort all of them by size
	.EXAMPLE
		PS C:\> Get-ValueFromPipe -pth <Your PATH>
	.INPUTS
		String / Array of strings
	.OUTPUTS
		Output
	.NOTES
		General notes
	#>
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline = $true)]
		[string]$pth
	)
	process{
		Get-ChildItem -Path $pth | Sort-Object -Property Size -Descending
	}
}

# Test 1 (shows work with pipeline)
Get-ChildItem -Path ".." -Directory | Select-Object FullName | Get-ValueFromPipe
# Test 2 (shows work with argument)
Get-ValueFromPipe -pth ".."
