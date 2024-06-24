//
//  ContentView.swift
//  WordScramble
//
//  Created by Radek Grzywacz on 23/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Text("Score: \(score)")
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word.capitalized)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button {
                    startGame()
                } label: {
                    Text("New word")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
             }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {return}
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "Message can't just make them up, you know!")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Minimumum length of the word is 3!")
            return
        }
        
        guard isStarWord(word: answer) else {
            wordError(title: "Start word used", message: "You can't just take your start word...")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        calculateScore(usedWords: usedWords)
        newWord = ""
    }
    
    func calculateScore(usedWords: [String]) {
        var lettersCount = 0
        var wordCount = 0
        for word in usedWords {
            wordCount += 1
            lettersCount += word.count
        }
        
        score = lettersCount * wordCount
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords  = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords.removeAll()
                score = 0
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isLongEnough(word: String) -> Bool {
        if(word.count < 3) {
            return false
        }
        
        return true
    }
    
    func isStarWord(word: String) -> Bool {
        if (word == rootWord) {
            return false
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspeledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspeledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    
}

#Preview {
    ContentView()
}
