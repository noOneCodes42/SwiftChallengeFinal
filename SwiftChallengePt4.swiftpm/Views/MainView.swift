//
//  MeanView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 9/7/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var countries: [RealmStructure]
    @Query private var tutorial: [Tutorial]
    
    var body: some View {
        Group {
            if !countries.isEmpty {
                if !tutorial.isEmpty {
                    MainTabView()
                        .preferredColorScheme(.light)
                } else {
                    TutorialView()
                }
            } else {
                ContentView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}

#Preview {
    MainView()
}
