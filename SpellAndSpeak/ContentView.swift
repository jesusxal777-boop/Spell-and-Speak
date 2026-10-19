import SwiftUI

struct ContentView: View {
    @StateObject private var speech = SpeechManager()
    @State private var inputText = ""
    @State private var currentWord = ""
    @State private var mode: Mode = .free
    @State private var feedback = ""
    @State private var score = 0
    
    private let wordList = [
        "CAT", "DOG", "BALL", "FISH", "BIRD", "TREE", "BOOK", "STAR",
        "MOON", "SUN", "CAR", "HOUSE", "APPLE", "BANANA", "ORANGE",
        "HAPPY", "SMILE", "FRIEND", "PLAY", "JUMP", "RUN", "SWIM",
        "RED", "BLUE", "GREEN", "YELLOW", "BLACK", "WHITE"
    ]
    
    enum Mode: String, CaseIterable {
        case free = "Free Speak"
        case spell = "Spell Mode"
        case letter = "Letter by Letter"
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("SPELL & SPEAK")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.green)
                    .shadow(color: .green.opacity(0.6), radius: 8)
                
                // Mode picker
                Picker("Mode", selection: $mode) {
                    ForEach(Mode.allCases, id: \.self) { m in
                        Text(m.rawValue).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Display area (retro style)
                Text(displayText)
                    .font(.system(size: 32, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.green)
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green.opacity(0.7), lineWidth: 2)
                            .background(Color.black)
                    )
                    .padding(.horizontal)
                
                // Input
                TextField("Type here...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                    .foregroundColor(.primary)
                
                // Buttons
                HStack(spacing: 16) {
                    Button(action: speakAction) {
                        Text(mode == .spell ? "CHECK" : "SPEAK")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    if mode == .spell {
                        Button(action: newWord) {
                            Text("NEW WORD")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: { speech.stop(); inputText = "" }) {
                        Text("CLEAR")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Feedback & score
                if !feedback.isEmpty {
                    Text(feedback)
                        .font(.title3)
                        .foregroundColor(feedback.contains("Correct") ? .green : .red)
                }
                
                if mode == .spell {
                    Text("Score: \(score)")
                        .font(.title2.monospaced())
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Text("Classic robotic voice approximation")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
        }
        .onAppear {
            if mode == .spell {
                newWord()
            }
        }
        .onChange(of: mode) { _ in
            inputText = ""
            feedback = ""
            if mode == .spell {
                newWord()
            }
        }
    }
    
    private var displayText: String {
        switch mode {
        case .free, .letter:
            return inputText.isEmpty ? "READY" : inputText.uppercased()
        case .spell:
            return currentWord.isEmpty ? "PRESS NEW WORD" : "????"
        }
    }
    
    private func speakAction() {
        switch mode {
        case .free:
            guard !inputText.isEmpty else { return }
            speech.speak(inputText)
        case .letter:
            guard !inputText.isEmpty else { return }
            speech.speak(inputText, letterByLetter: true)
        case .spell:
            checkSpelling()
        }
    }
    
    private func newWord() {
        currentWord = wordList.randomElement() ?? "CAT"
        inputText = ""
        feedback = ""
        // Speak the word for the user to spell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            speech.speak(currentWord)
        }
    }
    
    private func checkSpelling() {
        let answer = inputText.uppercased().trimmingCharacters(in: .whitespaces)
        if answer == currentWord {
            feedback = "Correct! Good job!"
            score += 1
            speech.speak("Correct")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                newWord()
            }
        } else {
            feedback = "Wrong. Try again or press NEW WORD"
            speech.speak("That is incorrect")
        }
    }
}

#Preview {
    ContentView()
}
