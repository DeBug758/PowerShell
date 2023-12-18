# Get the current date and time
$startTime = Get-Date
Write-Output "Started at $startTime"
Write-Output "Processing..."

# Check the number of arguments
if ($args.Count -ne 1) {
    Write-Output "Usage: $($MyInvocation.MyCommand.Name) <path_to_accounts.csv>"
    exit 1
}

# Check if the file exists
$filePath = $args[0]
if (-not (Test-Path $filePath)) {
    Write-Output "Error: File not found"
    exit 1
}

# Set up temporary and result file paths
$resFilePath = [System.IO.Path]::Combine((Get-Item $filePath).Directory.FullName, "accounts_new.csv")

$data = Import-Csv -Path $filePath
#Write-Output $data
$id = $data | Select-Object -ExpandProperty id
$location_id = $data | Select-Object -ExpandProperty location_id
$name = $data | Select-Object -ExpandProperty name
$title = $data.title
$title = $title | ForEach-Object {
    # Добавить двойные кавычки, если их нет
    if ($_ -like '*,*') {
        $_ = "`"$_`""
    }
    $_
}
$email = $data | Select-Object -ExpandProperty email
$department = $data | Select-Object -ExpandProperty department
$length = $id.Count

for ($i = 0; $i -lt $length; $i++){
	$words = $name[$i] -split ' '
	$capitalizedWords = $words | ForEach-Object {
		$firstChar = $_.Substring(0,1).ToUpper()
		$restOfWord = $_.Substring(1)
		$firstChar + $restOfWord
	}
	$name[$i] = $capitalizedWords -join ' '
	$str = "Name Surname"

	$words = $name[$i] -split ' '
	$firstLetterOfName = $words[0].Substring(0, 1)
	$surname = $words[1]
	$email[$i] = $firstLetterOfName.ToLower() + $surname.ToLower() + "@abc.com"
}
$email_copy = $email
for ($i = 0; $i -lt $length; $i++){
	$flag = 0
	for ($j = 0; $j -lt $length; $j++){
		if($i -eq $j){
			continue
		}
		elseif($email_copy[$i] -eq $email[$j]){
			$words = $email[$j] -split '@'
			$words[0] += $location_id[$j]
			$email[$j] = $words -join '@'
			$flag = 1
		}
	}
	if($flag -eq 1){
		$words = $email[$i] -split '@'
		$words[0] += $location_id[$i]
		$email[$i] = $words -join '@'
		$flag = 1
	}
}

New-Item -Path $resFilePath -ItemType File -Force
for ($i = 0; $i -lt $length; $i++) {
	if($i -eq 0){
		$line = "id,location_id,name,title,email,department"
		Add-Content -Path $resFilePath -Value $line
	}
    $line = "$($id[$i]),$($location_id[$i]),$($name[$i]),$($title[$i]),$($email[$i]),$($department[$i])"
    Add-Content -Path $resFilePath -Value $line
}
# Экспортируем данные в CSV файл
$data = Import-Csv -Path $resFilePath
#Write-Host $data
$endTime = Get-Date
