//
//  CarbonEmissionDailyController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class CarbonEmissionDailyController {
    var amount: Double = 0.0
    var modelContext: ModelContext?
    
    init() {
        // loadTodayAmount() will be called after setting the model context
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadTodayAmount()
    }
    
    private func loadTodayAmount() {
        guard let modelContext = modelContext else { return }
        
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
        
        let predicate = #Predicate<CarbonEmissionPerDay> { emission in
            emission.date >= todayStart && emission.date < tomorrowStart
        }
        
        let descriptor = FetchDescriptor<CarbonEmissionPerDay>(predicate: predicate)
        
        do {
            let results = try modelContext.fetch(descriptor)
            if let existing = results.first {
                amount = existing.amount
            } else {
                amount = 0.0
            }
        } catch {
            print("Failed to load today's amount: \(error)")
            amount = 0.0
        }
    }
    
    func addAmount(coinAmount: Double) {
        guard let modelContext = modelContext else { return }
        
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
        
        let predicate = #Predicate<CarbonEmissionPerDay> { emission in
            emission.date >= todayStart && emission.date < tomorrowStart
        }
        
        let descriptor = FetchDescriptor<CarbonEmissionPerDay>(predicate: predicate)
        
        do {
            let results = try modelContext.fetch(descriptor)
            
            if let existing = results.first {
                // same day → add
                existing.amount += coinAmount
                amount = existing.amount
            } else {
                // new day → create new entry that starts at coinAmount
                let newAmount = CarbonEmissionPerDay(amount: coinAmount, date: todayStart)
                modelContext.insert(newAmount)
                amount = coinAmount
            }
            
            try modelContext.save()
        } catch {
            print("Error occurred: \(error.localizedDescription)")
        }
    }
}
    