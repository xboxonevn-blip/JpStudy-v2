param(
    [int]$Port = 8787
)

Add-Type -AssemblyName System.Speech

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Windows TTS proxy running on http://localhost:$Port"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    try {
        if ($request.HttpMethod -ne 'POST' -or $request.Url.AbsolutePath -ne '/tts') {
            $response.StatusCode = 404
            $response.OutputStream.Close()
            continue
        }

        $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
        $body = $reader.ReadToEnd()
        $reader.Close()

        if ([string]::IsNullOrWhiteSpace($body)) {
            $response.StatusCode = 400
            $response.OutputStream.Close()
            continue
        }

        $payload = $body | ConvertFrom-Json
        $text = $payload.text
        $locale = $payload.locale
        $voice = $payload.voice

        if ([string]::IsNullOrWhiteSpace($text) -or [string]::IsNullOrWhiteSpace($locale)) {
            $response.StatusCode = 400
            $response.OutputStream.Close()
            continue
        }

        $gender = [System.Speech.Synthesis.VoiceGender]::NotSet
        if ($voice -eq 'male') { $gender = [System.Speech.Synthesis.VoiceGender]::Male }
        if ($voice -eq 'female') { $gender = [System.Speech.Synthesis.VoiceGender]::Female }

        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        try {
            $culture = New-Object System.Globalization.CultureInfo($locale)
            $synth.SelectVoiceByHints($gender, [System.Speech.Synthesis.VoiceAge]::NotSet, 0, $culture)
        } catch {
            try {
                $synth.SelectVoiceByHints($gender)
            } catch {
                # Fallback to default voice.
            }
        }

        $memory = New-Object System.IO.MemoryStream
        $synth.SetOutputToWaveStream($memory)
        $synth.Speak($text)
        $synth.Dispose()

        $bytes = $memory.ToArray()
        $memory.Dispose()

        $response.ContentType = 'audio/wav'
        $response.StatusCode = 200
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.OutputStream.Close()
    } catch {
        $response.StatusCode = 500
        $response.OutputStream.Close()
    }
}
