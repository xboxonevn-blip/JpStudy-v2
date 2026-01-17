# Google TTS proxy

This proxy keeps the Google Cloud key off the client by running TTS on a local
server (or your own backend). The Flutter app calls this proxy over HTTP.

## Setup
1) Create a Google Cloud project and enable Text-to-Speech API.
2) Create a service account key (JSON).
3) Set the credential path:
   - Windows (PowerShell): `$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\key.json"`
   - macOS/Linux: `export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"`

## Run
```
npm install
npm start
```

Default port is `8787`. Override with `TTS_PORT`.

## App config
Run Flutter with:
```
flutter run -d windows --dart-define=TTS_BASE_URL=http://localhost:8787
```

For mobile, use a reachable host IP (not localhost).

## Voice
The app can send `voice` as `female` or `male`. The proxy maps it to
`ssmlGender` for the selected locale.
