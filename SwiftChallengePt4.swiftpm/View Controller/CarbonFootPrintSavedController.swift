//
//  CarbonFootPrintSavedController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class CarbonFootPrintSavedController {
    var carbonFootPrintSaved = 0.0
    var modelContext: ModelContext?
    
    init() {
        // loadAmount() will be called after setting the model context
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadAmount()
    }

    func loadAmount() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CarbonFootPrintSaved>()
        do {
            let results = try modelContext.fetch(descriptor)
            if let saved = results.first {
                carbonFootPrintSaved = saved.carbonFootPrintSaved
            } else {
                carbonFootPrintSaved = 0
            }
        } catch {
            print("Failed to load carbon footprint: \(error)")
            carbonFootPrintSaved = 0
        }
    }
    
    func addAmount(coinAmount: Double) {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CarbonFootPrintSaved>()
        do {
            let results = try modelContext.fetch(descriptor)
            
            if let existing = results.first {
                existing.carbonFootPrintSaved += coinAmount
                carbonFootPrintSaved = existing.carbonFootPrintSaved
            } else {
                let newAmount = CarbonFootPrintSaved(carbonFootPrintSaved: coinAmount)
                modelContext.insert(newAmount)
                carbonFootPrintSaved = coinAmount
            }
            
            try modelContext.save()
        } catch {
            print("Error occurred: \(error)")
        }
    }
    
    func delete() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CarbonFootPrintSaved>()
        do {
            let results = try modelContext.fetch(descriptor)
            if let existing = results.first {
                modelContext.delete(existing)
                try modelContext.save()
            }
        } catch {
            print("Failed to delete: \(error)")
        }
    }
}
