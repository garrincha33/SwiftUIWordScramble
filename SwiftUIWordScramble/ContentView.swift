//
//  ContentView.swift
//  SwiftUIWordScramble
//
//  Created by Richard Price on 31/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord).autocapitalization(.none)
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
        }.navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
