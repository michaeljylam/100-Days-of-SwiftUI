//
//  ContentView.swift
//  Project 2: GuessTheFlag
//
//  Created by Michael Lam on 2020-07-12.
//  Copyright © 2020 Michael Lam. All rights reserved.
//

import SwiftUI

struct FlagImage: ViewModifier {
    var text: String
    
    func body (content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.red)
                .clipShape(Circle())
                .shadow(color: .black, radius: 2)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(FlagImage(text: text))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreDescription = ""
    @State private var userScore = 0
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)    .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of:")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .watermarked(with: "HwS")
                    }
                }
                
                Text("Current score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreDescription), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                }
            )
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            scoreDescription = "Your score is \(userScore)."
        } else {
            scoreTitle = "Incorrect"
            if userScore != 0 {
                userScore -= 1
            }
            scoreDescription = "The correct answer is \(countries[correctAnswer]). \nYour score is \(userScore)."
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
