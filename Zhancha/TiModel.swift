//
//  TiModel.swift
//  Zhancha
//
//  Created by jk on 10/08/2024.
//
import SwiftUI
//import Foundation
import CoreMotion
//import AVFoundation

struct Block: Identifiable {
    let id: Int
    var values: [Int?] {[nil] + Array(((id * 3) + 1)...((id * 3) + 3))}
    var rotation: Angle = .zero
    var position: CGPoint = .zero
    var scale: CGFloat = 1.0
    
    var currentValue: Int? {
        let index = Int((rotation.degrees / 90).rounded()) % 4
        return values[index]
    }
    
    mutating func roll(with acceleration: CMAcceleration) {
        let force = 500.0 // Adjust this to change the throw distance
        let xOffset = CGFloat(acceleration.x * force)
        let yOffset = CGFloat(-acceleration.y * force) // Inverted because device y-axis is opposite to UI y-axis
        
        rotation = Angle(degrees: Double.random(in: 0...360))
        position = CGPoint(x: xOffset, y: yOffset)
        scale = CGFloat.random(in: 0.8...1.2)
    }
}

