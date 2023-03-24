$InstallerFolderPath = Join-Path $PSScriptRoot "InstallerFolder"
$AppListPath = Join-Path $PSScriptRoot "AppList.txt"

if (!(Test-Path $AppListPath)) {
    Write-Error "アプリ一覧ファイルが見つかりません。"
    return
}

$AppList = Get-Content $AppListPath

foreach ($App in $AppList) {
    $AppInfo = $App.Split(",")
    $AppName = $AppInfo[0].Trim()
    $InstallerPath = $AppInfo[1].Trim()

    if ($InstallerPath -eq "winget") {
        if ($null -ne (winget search $AppName -e)) {
            Write-Host "$AppName のインストールを開始します。"
            winget install $AppName -e
            Write-Host "$AppName のインストールが完了しました。"
        }
        else {
            Write-Error "$AppName はwingetでインストールできません。"
        }
    }
    else {
        if (Test-Path $InstallerPath) {
            Write-Host "$AppName のインストールを開始します。"
            Start-Process -FilePath $InstallerPath -ArgumentList "/silent" -Wait
            Write-Host "$AppName のインストールが完了しました。"
        }
        else {
            Write-Error "$AppName のインストーラーが見つかりません。"
        }
    }
}