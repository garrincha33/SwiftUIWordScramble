//
//  ContentView.swift
//  SwiftUIWordScramble
//
//  Created by Richard Price on 31/01/2022.
//

import SwiftUI

struct ScoreFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.largeTitle))
            .foregroundColor(.red)
    }
}

extension View {
    func CustomFont() -> some View {
        modifier(ScoreFont())
    }
}

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
 

    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord).autocapitalization(.none)
                    Text("Your score is \(score)")
                        .CustomFont()
                    
                    
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).square")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Restart") {
                    startGame()
                }
            }
            .onSubmit {
                    addNewWord()
                }
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            
        }
        
    }
    
    func addNewWord() {

        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        //validation
        guard isOriginal(word: answer) else {
            wordError(title: "This word has been used already", message: "please try another")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "word not possible", message: "you cant spell that from \(rootWord)")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "word not recognised", message: "you cant just make them up you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += 1
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
 
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    //MARK:- functions for game functionailty
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
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
