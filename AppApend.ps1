$InstallerFolderPath = Join-Path $PSScriptRoot "InstallerFolder"
$AppListPath = Join-Path $PSScriptRoot "AppList.txt"

# �A�v���ꗗ�t�@�C�������݂��Ȃ��ꍇ�A�쐬����
if (!(Test-Path $AppListPath)) {
    New-Item -ItemType File $AppListPath | Out-Null
}

# �A�v����o�^����
while ($true) {
    $NewApp = Read-Host "�ǉ��o�^����A�v������͂��Ă��������B(`q`�ŏI��)"
    if ($NewApp -eq "q") {
        break
    }

    $AppInfo = $null

    # winget�Ŏ擾�ł���ꍇ��winget�ŃC���X�g�[���A�ł��Ȃ��ꍇ�̓C���X�g�[���[���w�肷��
    if ($null -ne (winget search $NewApp -Exact)) {
        Write-Host "$NewApp ��winget�ŃC���X�g�[���ł��܂��B"
        $AppInfo = "$NewApp, winget"
    }
    else {
        Write-Host "$NewApp ��winget�ŃC���X�g�[���ł��܂���B�C���X�g�[���[�̃p�X����͂��Ă��������B"
        $InstallerPath = Read-Host "�C���X�g�[���[�̃p�X����͂��Ă��������B"
        $InstallerName = Split-Path $InstallerPath -Leaf
        $InstallerDestination = Join-Path $InstallerFolderPath $InstallerName
        if (!(Test-Path $InstallerFolderPath)) {
            New-Item -ItemType Directory $InstallerFolderPath | Out-Null
        }
        Copy-Item $InstallerPath -Destination $InstallerDestination
        Write-Host "$InstallerName �� $InstallerFolderPath �ɃR�s�[���܂����B"
        $AppInfo = "$NewApp, $InstallerDestination"
    }

    # �A�v���ꗗ�t�@�C���ɒǉ�����
    if ($AppInfo) {
        Add-Content $AppListPath $AppInfo
        Write-Host "$NewApp ���A�v���ꗗ�ɒǉ����܂����B"
    }
}

Write-Host "�o�^���I�����܂��B"