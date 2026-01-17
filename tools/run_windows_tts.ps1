param(
    [int]$Port = 8787
)

$root = Split-Path -Parent $PSScriptRoot
$proxyScript = Join-Path $root 'tools/tts_proxy_win/tts_proxy.ps1'

Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$proxyScript`" -Port $Port"
Start-Sleep -Seconds 1

Set-Location $root
flutter run -d windows --dart-define=TTS_BASE_URL=http://localhost:$Port
