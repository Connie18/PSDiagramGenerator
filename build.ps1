Write-Host "[BUILD][START] Launching Build Process" -ForegroundColor Green

# Retrieve parent dir
$ModuleName = "PSDiagramGenerator"
$ArtifactDirPath = Join-Path -Path $PSScriptRoot -ChildPath $ModuleName
$ArtifactPath = Join-Path -Path $ArtifactDirPath -ChildPath "$($ModuleName).psm1"

if (Test-Path $ArtifactPath) {
    Write-Host "[BUILD][.psm1] .psm1 file detected. Deleting..." -ForegroundColor Green
    Remove-Item -Path $ArtifactPath -Force
}

$Date = Get-Date
"# Generated at $($Date)" | Out-File -FilePath $ArtifactPath -Encoding utf8 -Append

Write-Host "[BUILD][Code] Loading public and private functions" -ForegroundColor Green

$ModuleDirPath = Join-Path -Path $PSScriptRoot -ChildPath "module"
$PrivateFunctions = Get-ChildItem -Path "$ModuleDirPath\Private" -Filter *.ps1
$PublicFunctions = Get-ChildItem -Path "$ModuleDirPath\Public" -Filter *.ps1

$ArtifactContent = @()
$ArtifactContent += $PrivateFunctions
$ArtifactContent += $PublicFunctions

# Creating .psm1
Write-Host "[BUILD][START][.psm1] Building .psm1 file" -ForegroundColor Green
Foreach ($Content in $ArtifactContent) {
    Get-Content $Content.FullName | Out-File -FilePath $ArtifactPath -Encoding utf8 -Append
}

Write-Host "[BUILD][START][.psd1] Adding functions to export" -ForegroundColor Green

$FunctionsToExport = $PublicFunctions.BaseName
$Manifest = Join-Path -Path $ArtifactDirPath -ChildPath "$($ModuleName).psd1"
Update-ModuleManifest `
-Path $Manifest `
-Author 'Yuichiro Kondo' `
-Copyright '(c) Yuichiro Kondo. All rights reserved.' `
-Description 'Provides commands that generate diagrams for mermaid and PlantUML.' `
-PowerShellVersion '5.0' `
-FunctionsToExport $FunctionsToExport `
-RequiredModules @("PSClassUtils")

Write-Host "[BUILD][END] End of Build Process" -ForegroundColor Green
