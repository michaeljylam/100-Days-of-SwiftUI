//
//  ContentView.swift
//  M1-RockPaperScissors
//
//  Created by Michael Lam on 2022-07-28.
//

import SwiftUI

struct ContentView: View {
    let choices = ["Rock", "Paper", "Scissors"]
    let choicesIcons = ["✊", "✋", "✌️"]
    @State private var cpuChoice = Int.random(in: 0...2)
    @State private var playerShouldWin = Bool.random()
    @State private var correctMoves = 0
    @State private var round = 1
    
    @State private var showResults = false
    @State private var results = "Correct!"
    
    var body: some View {
        ZStack {
            if playerShouldWin {
                Color(red: 175/255, green: 255/255, blue: 160/255)
                    .ignoresSafeArea()
            } else {
                Color(red: 255/255, green: 115/255, blue: 140/255)
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                Text("Rock Paper Scissors Challenge")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
                
                if playerShouldWin {
                    Text("Defeat")
                        .fontWeight(.bold)
                } else {
                    Text("Lose against")
                        .fontWeight(.bold)
                }
                
                HStack(spacing: 0) {
                    Text(choicesIcons[cpuChoice])
                        .font(.system(size: 50))
                    Text(choices[cpuChoice])
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                }
                
                HStack {
                    ForEach(0 ..< 3) { i in
                        Button(action: {
                            calculateResults(with: i)
                        }) {
                            Text("\(choicesIcons[i]) \(choices[i])")
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .padding(8)
                        }
                        .background(.regularMaterial, in: Capsule())
                        .disabled(showResults)
                    }
                }
                
                Spacer()
                Text("\(correctMoves) out of \(round) correct moves")
                    .fontWeight(.bold)
                Text(results)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(showResults ? 1 : 0)
                Spacer()
            }
        }
    }
    
    func calculateResults(with playerChoice: Int) {
        if playerShouldWin {
            if (cpuChoice == 0 && playerChoice == 1) || (cpuChoice == 1 && playerChoice == 2) || (cpuChoice == 2 && playerChoice == 0) {
                results = "Correct!"
                correctMoves += 1
            } else {
                if cpuChoice == 0 {
                    results = "The correct move was ✋ Paper"
                } else if cpuChoice == 1 {
                    results = "The correct move was ✌️ Scissors"
                } else {
                    results = "The correct move was ✊ Rock"
                }
            }
        } else {
            if (cpuChoice == 0 && playerChoice == 2) || (cpuChoice == 1 && playerChoice == 0) || (cpuChoice == 2 && playerChoice == 1) {
                results = "Correct!"
                correctMoves += 1
            } else {
                if cpuChoice == 0 {
                    results = "The correct move was ✌️ Scissors"
                } else if cpuChoice == 1 {
                    results = "The correct move was ✊ Rock"
                } else {
                    results = "The correct move was ✋ Paper"
                }
            }
        }
        round += 1
        
        withAnimation {
            showResults = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
            withAnimation {
                showResults = false
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.75, execute: {
            resetGame()
        })
    }
    
    func resetGame() {
        cpuChoice = Int.random(in: 0...2)
        playerShouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
