//
//  Coin.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 11/25/25.
//
import Foundation
import SwiftData

@Model
class CoinStorage: Identifiable {
    var id: UUID = UUID()
    var amount: Int = 0
    
    init(amount: Int = 0) {
        self.amount = amount
    }
}
