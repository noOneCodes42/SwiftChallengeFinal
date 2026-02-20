//
//  RectangleViewUsuable.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import Foundation

struct RectangleViewUseable: Identifiable{
    let id = UUID()
    let content: String
    let sfSymbol: String
    let worth: Int
    var completed = false
}
