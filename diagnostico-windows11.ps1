param(
    [string]$ReportPath = ".\relatorio-diagnostico-windows11.txt"
)

$ErrorActionPreference = 'SilentlyContinue'

function Get-InstalledAppsLike {
    param([string[]]$Patterns)

    $paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    $items = foreach ($path in $paths) {
        Get-ItemProperty -Path $path | Where-Object {
            $name = $_.DisplayName
            $name -and ($Patterns | Where-Object { $name -match $_ })
        } | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    }

    $items | Sort-Object DisplayName -Unique
}

function Add-Section {
    param(
        [string]$Title,
        [object]$Data
    )

    "`r`n=== $Title ===`r`n" | Out-File -FilePath $ReportPath -Append -Encoding UTF8

    if ($null -eq $Data) {
        'Sem dados.' | Out-File -FilePath $ReportPath -Append -Encoding UTF8
        return
    }

    if ($Data -is [string]) {
        $Data | Out-File -FilePath $ReportPath -Append -Encoding UTF8
        return
    }

    $Data | Format-Table -AutoSize | Out-String -Width 300 | Out-File -FilePath $ReportPath -Append -Encoding UTF8
}

if (Test-Path $ReportPath) {
    Remove-Item $ReportPath -Force
}

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, VolumeName, @{N='Size_GB';E={[math]::Round($_.Size/1GB,1)}}, @{N='Free_GB';E={[math]::Round($_.FreeSpace/1GB,1)}}, @{N='Free_%';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}}
$topCpu = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 Name, Id, CPU, @{N='WS_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, Handles, StartTime
$topMem = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 Name, Id, @{N='WS_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, @{N='CPU_s';E={[math]::Round($_.CPU,1)}}
$startup = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Sort-Object Name
$runningServices = Get-Service | Where-Object Status -eq 'Running' | Select-Object Name, DisplayName, StartType | Sort-Object DisplayName
$backgroundTargets = Get-Process | Where-Object { $_.ProcessName -match 'AnyDesk|SyncTrayzor|syncthing|OneDrive|Widget|Teams|OpenVPN|msedgewebview2|Discord' } | Select-Object ProcessName, Id, @{N='WS_MB';E={[math]::Round($_.WorkingSet64/1MB,1)}}, CPU
$aiServices = Get-CimInstance Win32_Service | Where-Object { $_.Name -match 'AI|Copilot|OpenAI|Ollama|Whisper|GPT|Assistant' -or $_.DisplayName -match 'AI|Copilot|OpenAI|Ollama|Whisper|GPT|Assistant' } | Select-Object Name, DisplayName, State, StartMode, PathName
$aiTasks = Get-ScheduledTask | Where-Object { $_.TaskName -match 'AI|Copilot|OpenAI|Ollama|Whisper|GPT|Assistant' -or $_.TaskPath -match 'AI|Copilot|OpenAI|Ollama|Whisper|GPT|Assistant' } | Select-Object TaskName, TaskPath, State
$appx = Get-AppxPackage | Where-Object { $_.Name -match 'Copilot|Cortana|Teams|Widgets|WebExperience|Xbox|YourPhone|Clipchamp' } | Select-Object Name, PackageFullName
$installedMatches = Get-InstalledAppsLike -Patterns @('AI','Copilot','OpenAI','Ollama','LM Studio','Whisper','Stable','Diffusion','GPT','Assistant','NVIDIA','Teams','Xbox','Phone')

$summary = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    Windows = $os.Caption
    Version = $os.Version
    Build = $os.BuildNumber
    UptimeHours = [math]::Round(((Get-Date) - $os.LastBootUpTime).TotalHours, 2)
    TotalRAM_GB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    FreeRAM_GB = [math]::Round($os.FreePhysicalMemory * 1KB / 1GB, 2)
}

Add-Section -Title 'Resumo do sistema' -Data $summary
Add-Section -Title 'Espaco em disco' -Data $drives
Add-Section -Title 'Top processos por CPU' -Data $topCpu
Add-Section -Title 'Top processos por memoria' -Data $topMem
Add-Section -Title 'Inicializacao automatica' -Data $startup
Add-Section -Title 'Servicos em execucao' -Data $runningServices
Add-Section -Title 'Processos de background relevantes' -Data $backgroundTargets
Add-Section -Title 'Servicos relacionados a IA' -Data $aiServices
Add-Section -Title 'Tarefas agendadas relacionadas a IA' -Data $aiTasks
Add-Section -Title 'Pacotes Appx consumer e extras' -Data $appx
Add-Section -Title 'Aplicativos instalados com termos relacionados' -Data $installedMatches

Write-Host "Relatorio salvo em: $((Resolve-Path $ReportPath).Path)"
