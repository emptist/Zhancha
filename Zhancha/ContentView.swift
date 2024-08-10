//
//  ContentView.swift
//  Zhancha
//
//  Created by jk on 10/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack {
                scoreBoard
                blocksView
                throwInstructions
            }
        }
        .overlay(gameOverOverlay)
    }
    
    var backgroundImage: some View {
        Image("wooden_table")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
    
    var scoreBoard: some View {
        VStack {
            Text("Throw count: \(viewModel.throwCount)")
                .font(.headline)
            Text("Total sum: \(viewModel.totalSum)")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
    
    var blocksView: some View {
        ZStack {
            ForEach(viewModel.blocks) { block in
                BlockView(block: block)
            }
        }
        .frame(width: 300, height: 300)
    }
    
    var throwInstructions: some View {
        Text("Shake your device to throw the blocks!")
            .font(.headline)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
    }
    
    var gameOverOverlay: some View {
        Group {
            if viewModel.gameOver {
                VStack {
                    Text("Game Over!")
                        .font(.largeTitle)
                    Text("Final Score: \(viewModel.totalSum)")
                        .font(.title)
                    Button("Play Again") {
                        viewModel.resetGame()
                        viewModel.startMonitoringMotion()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .transition(.scale)
            }
        }
    }
}


struct BlockView: View {
    let block: Block
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.brown)
                .frame(width: 60, height: 60)
                .shadow(radius: 5)
            
            if let value = block.currentValue {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .rotation3DEffect(block.rotation, axis: (x: CGFloat.random(in: 0...1),
                                                 y: CGFloat.random(in: 0...1),
                                                 z: CGFloat.random(in: 0...1)))
        .position(block.position)
        .scaleEffect(block.scale)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
