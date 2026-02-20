//
//  CalendarRealmModel.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//


import Foundation
import SwiftData

@Model
class CalendarRealmModel: Identifiable {
    var id: UUID = UUID()
    var modelName: String = "earth_intense"
    var carbonSaved: Double = 0.0
    var date: Date = Date()
    
    init(modelName: String = "earth_intense", carbonSaved: Double = 0.0, date: Date = Date()) {
        self.modelName = modelName
        self.carbonSaved = carbonSaved
        self.date = date
    }
}
