//
//  StaticData.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/13/26.
//

import Foundation

struct SavedPoint: Equatable {
    let x: Float
    let y: Float
    let z: Float
    let modelName: String
    let scale: Float
    let id: String
    
    static func == (lhs: SavedPoint, rhs: SavedPoint) -> Bool {
        return lhs.x == rhs.x &&
               lhs.y == rhs.y &&
               lhs.z == rhs.z &&
               lhs.modelName == rhs.modelName &&
               lhs.scale == rhs.scale
    }
}

