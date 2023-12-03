function Write-ColoredMessage{
	param(
		[switch]$Red,
		[switch]$Blue,
		[string]$Text
	)
	if($Red){
		Write-Host -ForegroundColor Red $Text
	}
	elseif($Blue){
		Write-Host -ForegroundColor Blue $Text
	}
	else{
		Write-Host $Text
	}
}
