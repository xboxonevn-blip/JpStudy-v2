# Windows TTS proxy (free)

This proxy uses Windows built-in TTS (SAPI). No API key is required.

## Run
```
powershell -ExecutionPolicy Bypass -File tools/tts_proxy_win/tts_proxy.ps1 -Port 8787
```

Then run Flutter with:
```
flutter run -d windows --dart-define=TTS_BASE_URL=http://localhost:8787
```

Note: For Japanese voice quality, install the Japanese speech pack in Windows
Settings > Time & Language > Language & region.
