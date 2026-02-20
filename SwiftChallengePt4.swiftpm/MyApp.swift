import SwiftUI
import SwiftData

@main
struct MyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                RealmStructure.self,
                CalendarRealmModel.self,
                CarbonFootPrintSaved.self,
                CoinStorage.self,
                Tutorial.self,
                CarbonEmissionPerDay.self,
                ModelStorage.self
            ])
            
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            
            container = try ModelContainer(for: schema, configurations: [config])
            
            print("✅ SwiftData container initialized successfully")
            print("📦 Schema includes \(schema.entities.count) entities")
            
            // Log the container's context for debugging
            let context = container.mainContext
            print("📍 ModelContext created: \(context)")
            
        } catch {
            print("❌ Failed to initialize ModelContainer: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(container)
    }
}
