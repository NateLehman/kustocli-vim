# Microsoft.Azure.Kusto.Tools installer script
#
# Works on: Microsoft Windows

$kustoToolsSearch = Invoke-RestMethod -Uri "https://azuresearch-usnc.nuget.org/query?q=PackageId:Microsoft.Azure.Kusto.Tools&prerelease=false"

$packageUrl = "https://www.nuget.org/api/v2/package/$($kustoToolsSearch.data[0].id)/$($kustoToolsSearch.data[0].version)"

$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

$packageOut = "$($scriptDir)\..\bin\$($kustoToolsSearch.data[0].id).$($kustoToolsSearch.data[0].version).nupkg.zip"

Invoke-WebRequest -Uri $packageUrl -OutFile $packageOut

$installLocation = "$($scriptDir)\..\bin\KustoTools"
New-Item -ItemType Directory -Force -Path $installLocation | Out-Null

Expand-Archive -Path $packageOut -Destination $installLocation

if (Test-Path -Path "$($installLocation)\tools\Kusto.Cli.exe") {
    exit 0
} else {
    exit 1
}
