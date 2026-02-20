//
//  SignOut.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import Foundation
import SwiftData

class SignOut {
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func signOut() {
        guard let modelContext = modelContext else { return }
        
        do {
            // Delete all data from all models
            try modelContext.delete(model: RealmStructure.self)
            try modelContext.delete(model: CalendarRealmModel.self)
            try modelContext.delete(model: CarbonFootPrintSaved.self)
            try modelContext.delete(model: CoinStorage.self)
            try modelContext.delete(model: Tutorial.self)
            try modelContext.delete(model: CarbonEmissionPerDay.self)
            try modelContext.delete(model: ModelStorage.self)
            try modelContext.save()
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
}
