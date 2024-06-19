//
//  ContentView.swift
//  Rock_paper_scisors
//
//  Created by Radek Grzywacz on 19/06/2024.
//

import SwiftUI

struct ContentView: View {
    private let moves = ["👊", "✋", "✌️"]
    @State private var shouldWin = Bool.random()
    @State private var appsMove = Int.random(in: 0...2)
    @State private var score = 0
    @State private var roundsCount = 1
    @State private var isPresent = false
    
    func result(playersChoice: Int) {
        let winMoves = [1, 2, 0] 
        
        if (shouldWin && winMoves[appsMove] == playersChoice) || (!shouldWin && winMoves[playersChoice] == appsMove) {
            score += 1
        } else {
            score -= 1
        }
        
        if roundsCount >= 10 {
            isPresent = true
        } else {
            reset()
        }
    }
    
    func finish() {
        score = 0
        roundsCount = 1
        reset()
    }
    
    func reset() {
        roundsCount += 1
        shouldWin = Bool.random()
        appsMove = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.green, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Rock, Paper, Scissors")
                    .font(.title.bold())
                    .foregroundStyle(.secondary)
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("Score: \(score)")
                    .padding()
                    .font(.system(.title2))
                    .foregroundStyle(.white)
                
                VStack {
                    VStack {
                        Text("App's move:")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                        Text("\(moves[appsMove])")
                            .font(.system(size: 90))
                        
                        Text("How to \(shouldWin ? "win" : "lose") this?")
                            .foregroundStyle(.white)
                        
                        HStack {
                            ForEach(0..<moves.count, id: \.self) { index in
                                Button(action: {
                                    result(playersChoice: index)
                                }) {
                                    Text(moves[index])
                                        .font(.system(size: 60))
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .alert("Game finished!", isPresented: $isPresent) {
                Button("Continue", action: finish)
            } message: {
                Text("You scored \(score)/10")
            }
        }
    }
}

#Preview {
    ContentView()
}
