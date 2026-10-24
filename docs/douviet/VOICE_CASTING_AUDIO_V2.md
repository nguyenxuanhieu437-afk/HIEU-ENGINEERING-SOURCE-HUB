# DouViet Studio — Voice Casting Engine 2.0 & Cinematic Audio Mixer

**Status:** experimental documentation / research proposal. **Source report:** 24/10/2026. **Indexed:** 25/10/2026.

This is an original technical summary of user-supplied research notes, **not working source code or evidence of integration**. No external code, models, voices, video, audio, or third-party images are redistributed.

## Objective

Localize Chinese-language video into natural Vietnamese dialogue while retaining the source film's music, ambience, and sound effects. Select a stable voice appropriate to each character and expressive context.

## Proposed pipeline

1. **Rights and media intake:** record permitted use, file integrity, timecodes and streams.
2. **Source separation:** isolate dialogue and preserve a background stem; assess residual speech and artifacts.
3. **Diarization and acoustic profiling:** assign speaker IDs, estimate pitch, pace, loudness and emotion with confidence flags.
4. **Contextual Vietnamese localization:** preserve relationships, names, negation and numbers; carry stable utterance IDs through each stage.
5. **Voice casting / TTS:** match speakers to appropriately licensed Vietnamese voices, preserve character consistency, and time-align synthesized speech.
6. **Cinematic mixing:** duck background beneath speech only, restore it between lines, preserve effects and avoid clipping, pumping or abrupt transitions.
7. **Export and verification:** validate media streams, translation coverage, dubbing completeness, synchronization and sampled scene quality.

## Candidate components (research references only)

| Capability | Candidate repositories | Review before use |
|---|---|---|
| Vietnamese TTS | [VieNeu-TTS](https://github.com/pnnbao97/VieNeu-TTS) | Model weights, voice rights, license, output quality |
| Voice conversion | [OpenVoice](https://github.com/myshell-ai/OpenVoice), [RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) | Consent, licensing, Vietnamese compatibility |
| Speaker diarization | [pyannote-audio](https://github.com/pyannote/pyannote-audio) | Model access, overlapping speakers |
| Acoustic analysis | [librosa](https://github.com/librosa/librosa), [Parselmouth](https://github.com/YannickJadoul/Parselmouth) | Pitch reliability in noisy speech |
| Audio separation | [python-audio-separator](https://github.com/nomadkaraoke/python-audio-separator) | Stem quality and model license |
| Mixing and rendering | [FFmpeg](https://github.com/FFmpeg/FFmpeg) | Build/license requirements, render QA |

Links identify potential tools; they do **not** establish that any tool or model has been installed, licensed, tested, or integrated into DouViet.

## Acceptance gates

- **G1 provenance:** content and voice permissions established; no private media or credentials distributed.
- **G2 speech coverage:** all source utterances mapped to Vietnamese speech or an explicit unresolved status.
- **G3 identity:** stable voice per speaker, with uncertainty flagged.
- **G4 mix:** music/ambience/effects retained, no significant clipping or severe separation artifacts in sampled scenes.
- **G5 export:** output MP4 actually contains Vietnamese dialogue and the intended soundtrack, verified by listening and stream checks.
- **G6 release:** authorized end-to-end sample tests and component license reviews completed.

## Deduplication and provenance

Two Library files — `Văn bản đã dán (1)(5).txt` and `Văn bản đã dán (1)(6).txt` — contain identical **extracted text** and are indexed once. The original reports are not republished verbatim; third-party screenshots and image URLs are excluded. See [source manifest](VOICE_CASTING_AUDIO_V2_MANIFEST.json). The checksum covers extracted UTF-8 text, not raw uploaded bytes.

**Not verified:** engine installation, voice/model licensing, DouViet integration, performance, actual dubbing quality, or end-to-end video rendering.
