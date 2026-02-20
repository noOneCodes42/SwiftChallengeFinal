//
//  RealmStructure.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 9/2/25.
//

import Foundation
import SwiftData

@Model
class RealmStructure: Identifiable {
    var id: UUID = UUID()
    var country: String = ""
    
    init(country: String = "") {
        self.country = country
    }
}
