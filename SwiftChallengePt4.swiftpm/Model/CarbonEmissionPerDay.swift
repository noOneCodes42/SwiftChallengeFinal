//
//  CarbonEmissionPerDay.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import Foundation
import SwiftData

@Model
class CarbonEmissionPerDay: Identifiable {
    var id: UUID = UUID()
    var amount: Double = 0.0
    var date: Date = Date()
    
    init(amount: Double = 0.0, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}
