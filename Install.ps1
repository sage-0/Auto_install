$InstallerFolderPath = Join-Path $PSScriptRoot "InstallerFolder"
$AppListPath = Join-Path $PSScriptRoot "AppList.txt"

if (!(Test-Path $AppListPath)) {
    Write-Error "�A�v���ꗗ�t�@�C����������܂���B"
    return
}

$AppList = Get-Content $AppListPath

foreach ($App in $AppList) {
    $AppInfo = $App.Split(",")
    $AppName = $AppInfo[0].Trim()
    $InstallerPath = $AppInfo[1].Trim()

    if ($InstallerPath -eq "winget") {
        if ($null -ne (winget search $AppName -e)) {
            Write-Host "$AppName �̃C���X�g�[�����J�n���܂��B"
            winget install $AppName -e
            Write-Host "$AppName �̃C���X�g�[�����������܂����B"
        }
        else {
            Write-Error "$AppName ��winget�ŃC���X�g�[���ł��܂���B"
        }
    }
    else {
        if (Test-Path $InstallerPath) {
            Write-Host "$AppName �̃C���X�g�[�����J�n���܂��B"
            Start-Process -FilePath $InstallerPath -ArgumentList "/silent" -Wait
            Write-Host "$AppName �̃C���X�g�[�����������܂����B"
        }
        else {
            Write-Error "$AppName �̃C���X�g�[���[��������܂���B"
        }
    }
}