//
//  CarbonFootPrintSaved.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import Foundation
import SwiftData

@Model
class CarbonFootPrintSaved: Identifiable {
    var id: UUID = UUID()
    var carbonFootPrintSaved: Double = 0.0
    
    init(carbonFootPrintSaved: Double = 0.0) {
        self.carbonFootPrintSaved = carbonFootPrintSaved
    }
}
