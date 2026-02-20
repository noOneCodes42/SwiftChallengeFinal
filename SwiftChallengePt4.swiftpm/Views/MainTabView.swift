//
//  MainView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/11/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var controllersInitialized = false
    
    // Initialize controllers immediately with empty context, will be set properly later
    @State private var coinController = CoinViewController()
    @State private var carbonSavedController = CarbonFootPrintSavedController()
    @State private var carbonSavedDaily = CarbonEmissionDailyController()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MainTaskView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet.rectangle.portrait")
                }
            IslandView()
                .tabItem {
                    Label("Island", systemImage: "tree.circle")
                }

            ARTabView()
                .tabItem {
                    Label("AR View", systemImage: "snowflake")
                }
            CalendarView()
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }

        }
        .environment(coinController)
        .environment(carbonSavedController)
        .environment(carbonSavedDaily)
        .preferredColorScheme(.light)
        .task {
            if !controllersInitialized {
                initializeControllers()
                controllersInitialized = true
            }
        }
    }
    
    private func initializeControllers() {
        print("🔧 MainTabView: Initializing controllers...")
        
        coinController.setModelContext(modelContext)
        carbonSavedController.setModelContext(modelContext)
        carbonSavedDaily.setModelContext(modelContext)
        
        print("✅ MainTabView: Controllers initialized with ModelContext")
    }
}

#Preview {
    MainTabView()
}
