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
    @State private var launchScreen = true
    var body: some Scene {
        WindowGroup {
            if launchScreen {
                XcodeOnBoardingView(foregroundColor: .white) { isAnimating in
                    
                    Image("AppIconLaunchScreen")
                        .resizable()
                        .frame(width: 385, height: 385)

                        .scaleEffect(isAnimating ? 0.5 : 1)
                        .foregroundStyle(.white)
                } content: { isAnimating in
                    VStack(spacing: 15){
                        Text("Welcome To EcoHelp")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .padding(.top, 20)
                            .task {
                                try? await Task.sleep(for: .seconds(2.7))
                                launchScreen = false
                            }

                    }
                }
            } else {
                MainView()
            }
        }
        .modelContainer(container)
    }
}
