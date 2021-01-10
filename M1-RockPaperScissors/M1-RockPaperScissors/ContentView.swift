//
//  ContentView.swift
//  Milestone 1: RockPaperScissors
//
//  Created by Michael Lam on 2021-01-09.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    let moveIcons = ["✊", "✋", "✌️"]
    @State private var cpuMove = Int.random(in: 0...2)
    @State private var playerShouldWin = Bool.random()
    @State private var playerScore = 0
    @State private var round = 1
    @State private var showResults = false
    @State private var resultsTitle = ""
    @State private var resultsDescription = ""
    
    var body: some View {
        VStack {
            Text("Rock Paper Scissors Trainer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                
            Spacer()
            Text("CPU chose \(moveIcons[cpuMove]) \(moves[cpuMove]).")
            if playerShouldWin {
                Text("Defeat the CPU!")
            } else {
                Text("Lose against the CPU!")
            }
            HStack(spacing: 10) {
                ForEach(0 ..< 3) { i in
                    Button(action: {
                        self.moveChosen(i)
                    }) {
                        Text(moveIcons[i] + " " + moves[i])
                            .bold()
                            .padding(8)
                            .foregroundColor(.primary)
                    }
                    .background(Capsule().stroke(lineWidth: 2))
                }
            }
            
            Spacer()
            Text("Round \(round)")
                .bold()
            Text("Score: \(playerScore)")
                .bold()
                .padding(.bottom)
        }
        .alert(isPresented: $showResults, content: {
            Alert(title: Text(resultsTitle), message: Text(resultsDescription), dismissButton: .default(Text("Continue")) {
                self.resetGame()
            })
        })
    }
    
    func moveChosen(_ playerMove: Int) {
        if playerShouldWin {
            if (cpuMove == 0 && playerMove == 1) || (cpuMove == 1 && playerMove == 2) || (cpuMove == 2 && playerMove == 0) {
                resultsTitle = "Correct"
                playerScore += 1
                resultsDescription = "Your current score is \(playerScore)."
            } else {
                resultsTitle = "Incorrect"
                if playerScore != 0 {
                    playerScore -= 1
                }
                
                if cpuMove == 0 {
                    resultsDescription = "The correct move was Paper."
                } else if cpuMove == 1 {
                    resultsDescription = "The correct move was Scissors."
                } else {
                    resultsDescription = "The correct move was Rock."
                }
                resultsDescription += "\nYour current score is \(playerScore)."
            }
        } else {
            if (cpuMove == 0 && playerMove == 2) || (cpuMove == 1 && playerMove == 0) || (cpuMove == 2 && playerMove == 1) {
                resultsTitle = "Correct"
                playerScore += 1
                resultsDescription = "Your current score is \(playerScore)."
            } else {
                resultsTitle = "Incorrect"
                if playerScore != 0 {
                    playerScore -= 1
                }
                
                if cpuMove == 0 {
                    resultsDescription = "The correct move was Scissors."
                } else if cpuMove == 1 {
                    resultsDescription = "The correct move was Rock."
                } else {
                    resultsDescription = "The correct move was Paper."
                }
                resultsDescription += "\nYour current score is \(playerScore)."
            }
        }
        round += 1
        showResults = true
    }
    
    func resetGame() {
        cpuMove = Int.random(in: 0...2)
        playerShouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
