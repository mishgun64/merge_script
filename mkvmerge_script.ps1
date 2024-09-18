
Clear

$MKV_Files = Get-ChildItem -Path *.* -Include "*.mkv"
$Audio_Files = Get-ChildItem -Recurse -Include "*.ogg", "*.mka"
$Folders = @()
$X = 0
$MKV_Files_To_Do = @()
$Audio_Files_To_Do = @()

if ($Audio_Files -eq "") {
	Write-Host "There is no .mka or .ogg files"
}
else {
	foreach ($File in $Audio_Files) {
		$Path = ([System.IO.Path]::GetDirectoryName($File))
		if ($Folders -notcontains $Path) {
			$Folders += $Path			
		}
	}

	Write-Host "------------------------------------"
	Write-Host "You have the following audio tracks:"

	foreach ($Folder in $Folders) {
		$X++
		Write-Host $X")" $Folder.ToString().Split("\")[-1]
	}
	Write-Host "------------------------------------"
	$Choice = Read-Host "Select audio track"
	
	$Selected_Folder = $Folders[$Choice - 1]
    
	$Selected_Audio_Files =  Get-ChildItem -LiteralPath ([System.IO.DirectoryInfo] $Selected_Folder) -Include *.mka, *.ogg
	
	foreach ($File in $Selected_Audio_Files){
		$Audio_Files_To_Do += ([System.IO.Path]::GetFileNameWithoutExtension($File))
	}
	
	foreach ($File in $MKV_Files) {
		$Name = [System.IO.Path]::GetFileNameWithoutExtension($File)
		if ($Audio_Files_To_Do -contains $Name) {
			$MKV_Files_To_Do += $File
		}
	}

	Write-Host "------------------------------------------"
    Write-Host "You can add audio for the following files:"
	Write-Host ""

	foreach ($File in $MKV_Files_To_Do) {
		[System.IO.Path]::GetFileName($File)
	}

	Write-Host ""
	$Confirm = Read-Host "Do you confirm? (Y/N)"

	if ($Confirm -eq "Y") {
		Write-Host ""
		$Del_Confirm = Read-Host "Delete old files? (Y/N)"
		if ($Del_Confirm -eq "Y") {
			foreach ($File in $MKV_Files_To_Do) {
				$Dir = [System.IO.Path]::GetDirectoryName($File)
				$Name = [System.IO.Path]::GetFileNameWithoutExtension($File)
				$Container = [string]::Concat($Name,".mkv")
				$Audio_Extension = [System.IO.Path]::GetExtension((Get-ChildItem -LiteralPath ([System.IO.DirectoryInfo] $Selected_Folder) -Name *$Name*))
				$Audio_Track = [string]::Concat($Selected_Folder, "\", $Name, $Audio_Extension)
				$Result_Name = [string]::Concat($Name,"_new.mkv")
				C:\Program` Files\MKVToolNix\mkvmerge.exe -o $Result_Name  $Container --language 0:rus $Audio_Track
				Remove-Item -LiteralPath $File
				Rename-Item -LiteralPath ([string]::Concat($Dir, "\", $Result_Name))  -NewName $File
			}	
		}
		else {
			foreach ($File in $MKV_Files_To_Do) {
				$Dir = [System.IO.Path]::GetDirectoryName($File)
				$Name = [System.IO.Path]::GetFileNameWithoutExtension($File)
				$Container = [string]::Concat($Name,".mkv")
				$Audio_Extension = [System.IO.Path]::GetExtension((Get-ChildItem -LiteralPath ([System.IO.DirectoryInfo] $Selected_Folder) -Name *$Name*))
				$Audio_Track = [string]::Concat($Selected_Folder, "\", $Name, $Audio_Extension)
				$Result_Name = [string]::Concat($Name,"_new.mkv")
				C:\Program` Files\MKVToolNix\mkvmerge.exe -o $Result_Name  $Container --language 0:rus $Audio_Track
			}
		}
	}
 }