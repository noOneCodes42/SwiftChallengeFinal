//
//  RealmViewController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 9/2/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class RealmViewController {
    var valueExists: Bool = false
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func writeToRealm(country: String) {
        guard let modelContext = modelContext else { return }
        
        let countryOfOrigin = RealmStructure(country: country)
        modelContext.insert(countryOfOrigin)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save country: \(error)")
        }
    }
    
    func deleteFromRealm() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<RealmStructure>()
        do {
            let countries = try modelContext.fetch(descriptor)
            if let countryToDelete = countries.first {
                modelContext.delete(countryToDelete)
                try modelContext.save()
            }
        } catch {
            print("Failed to delete country: \(error)")
        }
    }
    
    func nameOfCountry() -> String {
        guard let modelContext = modelContext else { return "" }
        
        let descriptor = FetchDescriptor<RealmStructure>()
        do {
            let countries = try modelContext.fetch(descriptor)
            return countries.first?.country ?? ""
        } catch {
            print("Failed to fetch country: \(error)")
            return ""
        }
    }
}
