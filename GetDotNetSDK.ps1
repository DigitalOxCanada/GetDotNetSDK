#get the x64 sdk links from the download page
$links = (Invoke-WebRequest –Uri 'https://www.microsoft.com/net/download/visual-studio-sdks').Links | Where-Object href -like "*dotnet-sdk-*-windows-x64-installer*"

#show the version numbers only as a simple pick list
Write-Host "Choose version to download and install:";
$cnt = 0;
foreach ($l in $links.href)
{
    if($l -match "(?<=dotnet-sdk-)(.*?)(?=-windows-x64-installer)") {
        $cnt = $cnt + 1;
        Write-Host "[" $cnt "] " $Matches[1]
    }
}

#get the version chosen
$it = read-host "Choice ? [1/2/.../n]"
$veronly = "";
if ($links[$it-1].href -match "(?<=dotnet-sdk-)(.*?)(?=-windows-x64-installer)") {
    $veronly = $Matches[1];
}
#build the destination url based on version choice
$dotnetcoresdk_url = "https://www.microsoft.com" + $links[$it-1].href;
$dotnetcoresdk_exe = "$PSScriptRoot\dotnet-sdk-$veronly-sdk-win-x64.exe";
Write-Host "Downloading ($dotnetcoresdk_url) ...";

#the url is a webpage, not a file download only, but does have a try again link that contains the download url we want.
$u = invoke-webrequest "$dotnetcoresdk_url" -MaximumRedirection 0
$sourceadw = $u.Links | Where-Object {$_.outerHTML -like "*Try again*"} | Select-Object -expand href
Invoke-WebRequest $sourceadw -OutFile $dotnetcoresdk_exe 

Write-Host "Saved as ($dotnetcoresdk_exe)";

#run the exe installer
Start-Process $dotnetcoresdk_exe -Wait

