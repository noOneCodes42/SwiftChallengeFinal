
//
//  CoinViewController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/15/26.
//




import Foundation
import SwiftData
import SwiftUI
// Originally I made this project as an XCode app thinking that, that was supported for submission however it turns out it needed an .swiftpm. Which is why I had to convert from RealmSwift to SwiftData which is why some of the controllers name are realm  and not swiftdata. Along with why my file creations are off because I just copied my xcode app code here so the creation comments on the top are still related to the original xcode project. I just updated it from RealmSwift to SwiftData
@Observable
class CoinViewController {
    var currentAmount: Int = 0
    var modelContext: ModelContext?
    
    init() {
        // loadAmount() will be called after setting the model context
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        print("CoinViewController: ModelContext set")
        loadAmount()
    }

    func loadAmount() {
        guard let modelContext = modelContext else {
            return
        }
        
        let descriptor = FetchDescriptor<CoinStorage>()
        do {
            let results = try modelContext.fetch(descriptor)
            if let coin = results.first {
                currentAmount = coin.amount
            } else {
                currentAmount = 0
            }
        } catch {
            currentAmount = 0
        }
    }

    func addCoinToRealm(amount: Int) {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CoinStorage>()
        do {
            let results = try modelContext.fetch(descriptor)
            
            if let existing = results.first {
                existing.amount += amount
                currentAmount = existing.amount
            } else {
                let coinAmount = CoinStorage(amount: amount)
                modelContext.insert(coinAmount)
                currentAmount = amount
            }
            
            try modelContext.save()
        } catch {
            print("Failed to add coins: \(error)")
        }
    }
    
    func deleteCoinFromRealm(amount: Int) {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CoinStorage>()
        do {
            let results = try modelContext.fetch(descriptor)
            if let existingAmount = results.first {
                existingAmount.amount -= amount
                currentAmount = existingAmount.amount
                try modelContext.save()
            }
        } catch {
            print("Failed to delete coins: \(error)")
        }
        // No carbon update here — spending coins doesn't affect footprint
    }

    func removeCoinFromRealm(amount: Int) -> Bool {
        guard let modelContext = modelContext else { return false }
        
        let descriptor = FetchDescriptor<CoinStorage>()
        do {
            let results = try modelContext.fetch(descriptor)
            if let existing = results.first {
                existing.amount -= amount
                currentAmount = existing.amount
                try modelContext.save()
                return true
            } else {
                return false
            }
        } catch {
            print("Failed to remove coins: \(error)")
            return false
        }
        // No carbon update here either — same reason
    }

    func delete() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<CoinStorage>()
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
