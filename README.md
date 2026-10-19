# Spell & Speak

Tributo open-source al clásico Speak & Spell de los 80s.

## Características
- Modo Libre: escribe y la app habla
- Modo Spell: la app dice una palabra y tú la escribes
- Deletreo letra por letra
- Voz robótica estilo original (ajustes de rate/pitch + voz del sistema más cercana al Speak & Spell)
- Interfaz retro estilo display VFD

## Compilar IPA sin firmar (para Scarlet)

El workflow de GitHub Actions genera un **IPA sin firmar** automáticamente.

1. Ve a la pestaña **Actions** del repo
2. Ejecuta el workflow "Build Unsigned IPA" (botón Run workflow)
3. Descarga el artefacto `SpellAndSpeak-unsigned.ipa`
4. Transfiere el IPA al iPhone
5. Abre **Scarlet** → Sideload IPA → selecciona el archivo → firma e instala

## Notas sobre la voz
La voz exacta del Speak & Spell original (chip TI TMS5220 / LPC) no está disponible nativamente en iOS. Se aproxima usando `AVSpeechSynthesizer` con rate bajo, pitch ajustado y la voz del sistema más robótica disponible.

---
Hecho para que puedas usarlo sin Mac.