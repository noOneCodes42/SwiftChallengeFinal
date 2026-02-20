//
//  Tutorial.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//


import Foundation
import SwiftData

@Model
class Tutorial: Identifiable {
    var id: UUID = UUID()
    var completed: Bool = false
    
    init(completed: Bool = false) {
        self.completed = completed
    }
}
