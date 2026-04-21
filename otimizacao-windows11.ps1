param(
    [switch]$StopBackgroundApps = $true,
    [switch]$DisableStartupEntries = $true,
    [switch]$RemoveConsumerPackages = $true,
    [switch]$DisableWidgetsTasks = $true
)

$ErrorActionPreference = 'Continue'

function Write-Step {
    param([string]$Message)
    Write-Host "[INFO] $Message"
}

function Stop-TargetProcesses {
    $targets = @(
        'WidgetBoard',
        'WidgetService',
        'ms-teams',
        'PhoneExperienceHost',
        'YourPhone',
        'XboxAppServices',
        'GameBar',
        'AnyDesk',
        'SyncTrayzor',
        'syncthing',
        'OneDrive',
        'OpenVPNConnect',
        'Discord'
    )

    foreach ($name in $targets) {
        Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
}

function Disable-RunValue {
    param(
        [string]$RegistryPath,
        [string[]]$Names
    )

    if (-not (Test-Path $RegistryPath)) {
        return
    }

    foreach ($name in $Names) {
        if ($null -ne (Get-ItemProperty -Path $RegistryPath -Name $name -ErrorAction SilentlyContinue)) {
            Remove-ItemProperty -Path $RegistryPath -Name $name -Force -ErrorAction SilentlyContinue
            Write-Step "Inicializacao removida: $name"
        }
    }
}

function Disable-StartupShortcuts {
    $startupDirs = @(
        "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup",
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    )

    $patterns = 'AnyDesk','Discord','OneDrive','OpenVPN','SyncTrayzor'

    foreach ($dir in $startupDirs) {
        if (-not (Test-Path $dir)) {
            continue
        }

        Get-ChildItem -Path $dir -File | Where-Object {
            $fileName = $_.Name
            $patterns | Where-Object { $fileName -match $_ }
        } | ForEach-Object {
            $newName = "$($_.FullName).disabled"
            if (-not (Test-Path $newName)) {
                Rename-Item -Path $_.FullName -NewName ($_.Name + '.disabled') -Force -ErrorAction SilentlyContinue
                Write-Step "Atalho de inicializacao desativado: $($_.Name)"
            }
        }
    }
}

function Remove-ConsumerAppx {
    $patterns = @(
        'MicrosoftWindows.Client.WebExperience',
        'Microsoft.WidgetsPlatformRuntime',
        'MSTeams',
        'Microsoft.YourPhone',
        'Microsoft.XboxGamingOverlay',
        'Microsoft.XboxGameCallableUI',
        'Microsoft.XboxSpeechToTextOverlay',
        'Microsoft.XboxIdentityProvider'
    )

    foreach ($pattern in $patterns) {
        Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq $pattern } | ForEach-Object {
            Write-Step "Removendo pacote: $($_.Name)"
            Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        }

        Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $pattern } | ForEach-Object {
            Write-Step "Removendo provisionamento: $($_.DisplayName)"
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

function Disable-WidgetTasks {
    $candidates = @(
        '\Microsoft\Windows\Shell\FamilySafetyMonitor',
        '\Microsoft\Windows\Shell\FamilySafetyRefreshTask',
        '\Microsoft\Windows\Windows Feeds\SynchronizeLanguageSettings',
        '\Microsoft\Windows\Windows Feeds\BackgroundSynchronization',
        '\Microsoft\Windows\Windows Feeds\BackgroundDownload'
    )

    foreach ($task in $candidates) {
        $taskPath = Split-Path $task -Parent
        $taskName = Split-Path $task -Leaf
        if ($taskPath -and $taskName) {
            Disable-ScheduledTask -TaskPath ($taskPath + '\') -TaskName $taskName -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

function Disable-UnnecessaryServicesIfPresent {
    $services = @(
        'OpenVPNService',
        'agent_ovpnconnect',
        'ovpnhelper_service'
    )

    foreach ($svc in $services) {
        $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($service) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Manual -ErrorAction SilentlyContinue
            Write-Step "Servico ajustado para Manual: $svc"
        }
    }
}

if ($StopBackgroundApps) {
    Write-Step 'Encerrando processos de background selecionados'
    Stop-TargetProcesses
}

if ($DisableStartupEntries) {
    Write-Step 'Desativando entradas de inicializacao selecionadas'
    Disable-RunValue -RegistryPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Names @('Discord','OneDrive','org.openvpn.client','SyncTrayzor')
    Disable-RunValue -RegistryPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Names @('Discord','OneDrive','org.openvpn.client','SyncTrayzor','AnyDesk')
    Disable-StartupShortcuts
    Disable-UnnecessaryServicesIfPresent
}

if ($DisableWidgetsTasks) {
    Write-Step 'Desativando tarefas relacionadas a Widgets e Feeds'
    Disable-WidgetTasks
}

if ($RemoveConsumerPackages) {
    Write-Step 'Removendo Widgets, Teams, Seu Telefone e componentes Xbox'
    Remove-ConsumerAppx
}

Write-Step 'Otimizacao concluida. Reinicie o Windows para aplicar completamente as alteracoes.'
