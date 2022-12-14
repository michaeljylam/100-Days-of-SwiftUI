//
//  ContentView.swift
//  P5-WordScramble
//
//  Created by Michael Lam on 2022-06-12.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @FocusState private var textFieldIsFocused: Bool
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text(rootWord)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                List {
                    TextField("Enter your word", text: $newWord, onCommit: {
                        textFieldIsFocused = true
                    })
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($textFieldIsFocused)

                    Section(usedWords.count > 0 ? "Used Words" : "") {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Score: \(score)")
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("New Word") {
                        startGame()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count >= 3 else {
            wordError(title: "Word too short", message: "Find a word that is at least 3 letters long!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \"\(rootWord)\"!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make words up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score = score + newWord.count
        newWord = ""
    }
    
    func startGame() {
        usedWords.removeAll()
        score = 0
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word) && word != rootWord
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
