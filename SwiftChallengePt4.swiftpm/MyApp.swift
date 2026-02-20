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
            
            
            // Log the container's context for debugging
            let context = container.mainContext
            
        } catch {
            print("Error details: \(error.localizedDescription)")
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
