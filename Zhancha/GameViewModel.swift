//
//  GameViewModel.swift
//  Zhancha
//
//  Created by jk on 10/08/2024.
//

import SwiftUI
import Foundation
import AVFoundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var acceleration: CMAcceleration = .init(x: 0, y: 0, z: 0)
    
    init() {
        motionManager.accelerometerUpdateInterval = 1/60
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            self?.acceleration = data.acceleration
        }
    }
    
    func detectThrow() -> Bool {
        let throwThreshold: Double = 2.0 // Adjust this value to fine-tune throw detection
        return sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2)) > throwThreshold
    }
}

class GameViewModel: ObservableObject {
    @Published var blocks: [Block] = (0..<6).map { Block(id: $0) }
    @Published var throwCount = 0
    @Published var totalSum = 0
    @Published var isRolling = false
    @Published var gameOver = false
    
    let motionManager = MotionManager()
    var throwTimer: Timer?
    
    init() {
        startMonitoringMotion()
    }
    
    func startMonitoringMotion() {
        throwTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            if self?.motionManager.detectThrow() == true {
                self?.throwBlocks()
            }
        }
    }
    
    func throwBlocks() {
        guard !isRolling && throwCount < 3 else { return }
        
        isRolling = true
        
        for index in blocks.indices {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                blocks[index].roll(with: motionManager.acceleration)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.calculateSum()
            self.throwCount += 1
            self.isRolling = false
            
            if self.throwCount == 3 {
                self.gameOver = true
                self.throwTimer?.invalidate()
            }
        }
    }
    
    // ... (other methods remain the same)
    //     var audioPlayer: AVAudioPlayer?
    
    //     init() {
    //         setupAudio()
    //     }
    
    //     func setupAudio() {
    //         guard let soundURL = Bundle.main.url(forResource: "dice_roll", withExtension: "mp3") else { return }
    //         do {
    //             audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
    //             audioPlayer?.prepareToPlay()
    //         } catch {
    //             print("Error loading audio: \(error)")
    //         }
    //     }
    
    
    func calculateSum() {
        let sum = blocks.reduce(0) { $0 + (($1.currentValue ?? 0) * 1) }
        totalSum += sum
    }
    
    func resetGame() {
        blocks = (0..<6).map { Block(id: $0) }
        throwCount = 0
        totalSum = 0
        gameOver = false
    }
}



