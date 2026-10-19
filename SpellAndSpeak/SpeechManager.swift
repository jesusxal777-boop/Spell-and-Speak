import Foundation
import AVFoundation

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    // Approximate the classic Speak & Spell robotic voice
    // Original used TI TMS5220 LPC synthesizer (very robotic, limited formants)
    func speak(_ text: String, letterByLetter: Bool = false) {
        synthesizer.stopSpeaking(at: .immediate)
        
        if letterByLetter {
            for char in text.uppercased() where char.isLetter || char.isNumber {
                let utterance = makeUtterance(String(char))
                synthesizer.speak(utterance)
            }
        } else {
            let utterance = makeUtterance(text)
            synthesizer.speak(utterance)
        }
    }
    
    private func makeUtterance(_ text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        
        // Try to pick a more robotic / neutral voice
        // Prefer voices that sound less natural
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        }
        
        // Classic Speak & Spell characteristics:
        // - Slower rate
        // - Slightly lower pitch
        // - More monotone
        utterance.rate = 0.42          // slower than default (~0.5)
        utterance.pitchMultiplier = 0.85
        utterance.volume = 1.0
        utterance.preUtteranceDelay = 0.05
        utterance.postUtteranceDelay = 0.08
        
        return utterance
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
