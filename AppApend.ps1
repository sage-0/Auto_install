$InstallerFolderPath = Join-Path $PSScriptRoot "InstallerFolder"
$AppListPath = Join-Path $PSScriptRoot "AppList.txt"

# アプリ一覧ファイルが存在しない場合、作成する
if (!(Test-Path $AppListPath)) {
    New-Item -ItemType File $AppListPath | Out-Null
}

# アプリを登録する
while ($true) {
    $NewApp = Read-Host "追加登録するアプリを入力してください。(`q`で終了)"
    if ($NewApp -eq "q") {
        break
    }

    $AppInfo = $null

    # wingetで取得できる場合はwingetでインストール、できない場合はインストーラーを指定する
    if ($null -ne (winget search $NewApp -Exact)) {
        Write-Host "$NewApp はwingetでインストールできます。"
        $AppInfo = "$NewApp, winget"
    }
    else {
        Write-Host "$NewApp はwingetでインストールできません。インストーラーのパスを入力してください。"
        $InstallerPath = Read-Host "インストーラーのパスを入力してください。"
        $InstallerName = Split-Path $InstallerPath -Leaf
        $InstallerDestination = Join-Path $InstallerFolderPath $InstallerName
        if (!(Test-Path $InstallerFolderPath)) {
            New-Item -ItemType Directory $InstallerFolderPath | Out-Null
        }
        Copy-Item $InstallerPath -Destination $InstallerDestination
        Write-Host "$InstallerName を $InstallerFolderPath にコピーしました。"
        $AppInfo = "$NewApp, $InstallerDestination"
    }

    # アプリ一覧ファイルに追加する
    if ($AppInfo) {
        Add-Content $AppListPath $AppInfo
        Write-Host "$NewApp をアプリ一覧に追加しました。"
    }
}

Write-Host "登録を終了します。"