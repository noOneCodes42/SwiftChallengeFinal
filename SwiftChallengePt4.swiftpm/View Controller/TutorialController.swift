//
//  TutorialController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class TutorialController {
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func addValue() {
        guard let modelContext = modelContext else { return }
        
        do {
            let tutorialFinished = Tutorial(completed: true)
            modelContext.insert(tutorialFinished)
            try modelContext.save()
        } catch {
            print("Unable to write to database: \(error)")
        }
    }
}
