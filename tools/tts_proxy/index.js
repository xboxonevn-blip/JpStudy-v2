const cors = require('cors');
const express = require('express');
const textToSpeech = require('@google-cloud/text-to-speech');

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));

const client = new textToSpeech.TextToSpeechClient();

function pickVoice(locale, voice) {
  const gender = voice === 'male' ? 'MALE' : 'FEMALE';
  return { languageCode: locale, ssmlGender: gender };
}

app.get('/health', (_, res) => {
  res.json({ ok: true });
});

app.post('/tts', async (req, res) => {
  const { text, locale, voice } = req.body || {};
  if (!text || !locale) {
    res.status(400).json({ error: 'text and locale are required' });
    return;
  }
  try {
    const voiceConfig = pickVoice(locale, voice);
    const [response] = await client.synthesizeSpeech({
      input: { text },
      voice: voiceConfig,
      audioConfig: { audioEncoding: 'MP3' },
    });
    if (!response.audioContent) {
      res.status(500).json({ error: 'no audio content returned' });
      return;
    }
    res.set('Content-Type', 'audio/mpeg');
    res.send(response.audioContent);
  } catch (error) {
    console.error('TTS error', error);
    res.status(500).json({ error: 'tts_failed' });
  }
});

const port = Number(process.env.TTS_PORT || 8787);
app.listen(port, () => {
  console.log(`TTS proxy running on http://localhost:${port}`);
});
