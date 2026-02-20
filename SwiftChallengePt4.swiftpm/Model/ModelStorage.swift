//
//  ModelStorage.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import SwiftData
import Foundation

@Model
class ModelStorage: Identifiable {
    var id: UUID = UUID()
    var modelName: String = ""
    var uniqueID: String = ""
    var modelXAxis: Float = 0.0
    var modelYAxis: Float = 0.0
    var modelZAxis: Float = 0.0
    var modelScale: Float = 0.03
    
    init(modelName: String = "", uniqueID: String = "", modelXAxis: Float = 0.0, modelYAxis: Float = 0.0, modelZAxis: Float = 0.0, modelScale: Float = 0.03) {
        self.modelName = modelName
        self.uniqueID = uniqueID
        self.modelXAxis = modelXAxis
        self.modelYAxis = modelYAxis
        self.modelZAxis = modelZAxis
        self.modelScale = modelScale
    }
}
