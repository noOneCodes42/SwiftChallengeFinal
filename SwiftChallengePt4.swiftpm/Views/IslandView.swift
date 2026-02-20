//
// IslandView.swift
// Swift International Challenge P1
//
// Created by Neel Arora on 8/11/25.
//

import SwiftUI
import SwiftData
import RealityKit

struct IslandView: View {
    @Environment(\.modelContext) private var modelContext
    @State var showCard = true
    @State private var hasInteracted = false
    @State private var isDragging = false
    @State private var draggedEntity: Entity?
    @State private var dragStartPosition: SIMD3<Float> = .zero
    @Environment(CoinViewController.self) private var coinController
    @State private var isTouchingIsland = false
    @State private var showStats = false
    @State private var temp: Double = 37.7778
    @State private var showCelsius = true
    @State private var selectedModelName: String? = nil
    @State private var selectedModelScale: Float? = nil
    @State private var isPlacingModel = false
    @State private var tempDraggedEntity: Entity? = nil
    @State private var tempModelEntity: ModelEntity? = nil
    @State private var refreshID = UUID()
    @State private var loadedModels: [ModelEntity] = []
    @State private var entityScaleMap: [String: Float] = [:]
    @State private var showDebugMenu = false
    @State private var isNewPlacement = false
    
    @Query private var storedModels: [ModelStorage]



    var body: some View {
        ZStack {
            // Background island frame
            ColorScheme()
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 650)
                        .padding(.bottom, 260)
                        .foregroundStyle(.brown)
                }

            RealityView { content in
                let anchor = AnchorEntity()
                content.add(anchor)

                let modelsToLoad = Array(storedModels)
                print("Starting load of \(modelsToLoad.count) models")

                Task {
                    for storedModel in modelsToLoad {
                        print("Model Scale: \(storedModel.modelScale)")
                        print("Model Name: \(storedModel.modelName)")
                        print("Model Position: \(storedModel.modelScale)")
                        do {
                            // Load USDZ model from Bundle
                            guard let url = Bundle.main.url(forResource: storedModel.modelName, withExtension: "usdz", subdirectory: "3D Models") else {
                                print("Could not find \(storedModel.modelName).usdz in Bundle")
                                continue
                            }
                            
                            let model = try await ModelEntity(contentsOf: url)
                            print("Loaded island model: \(storedModel.modelName)")
                            
                            model.position = [storedModel.modelXAxis,
                                              storedModel.modelYAxis,
                                              storedModel.modelZAxis]
                            model.scale = [storedModel.modelScale,
                                           storedModel.modelScale,
                                           storedModel.modelScale]
                            model.generateCollisionShapes(recursive: true)
                            model.components.set(InputTargetComponent())


                            if !storedModel.uniqueID.isEmpty {
                                model.name = storedModel.uniqueID
                            } else {
                                let newID = UUID().uuidString
                                model.name = newID
                                storedModel.uniqueID = newID
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Error writing uniqueID: \(error.localizedDescription)")
                                }
                            }

                            entityScaleMap[model.name] = storedModel.modelScale
                            storeOriginalMaterials(entity: model)
                            anchor.addChild(model)
                            print("Added \(storedModel.modelName) with ID \(model.name)")
                        } catch {
                            print("Failed \(storedModel.modelName): \(error)")
                        }
                    }
                    print("ALL \(modelsToLoad.count) models processed")
                }
            } update: { content in
                // Spawn a new model only when doing a NEW placement
                if isPlacingModel,
                   isNewPlacement,
                   let model = tempModelEntity,
                   tempDraggedEntity == nil {
                    print("Spawning new model for placement")
                    model.position = [0, 0, 0.2]
                    let useScale = selectedModelScale ?? 0.03
                    model.scale = [useScale, useScale, useScale]
                    model.generateCollisionShapes(recursive: true)
                    model.components.set(InputTargetComponent())

                    let uniqueID = UUID().uuidString
                    model.name = uniqueID
                    entityScaleMap[uniqueID] = useScale

                    storeOriginalMaterials(entity: model)
                    content.add(model)
                    tempDraggedEntity = model
                    draggedEntity = model
                    dragStartPosition = model.position
                    print("Model spawned with ID: \(uniqueID)")
                }

                if isDragging, let entity = draggedEntity {
                    applyHolographicMaterial(to: entity, touching: isTouchingIsland)
                } else {
                    for entity in content.entities {
                        restoreOriginalMaterials(entity: entity)
                    }
                }
            }
            .id(refreshID)

          
            .overlay {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Button {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                    showDebugMenu.toggle()
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 48, height: 48)
                                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                            if showDebugMenu {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Debug Menu")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 4)
                                    Text("Models in DB \(storedModels.count)")
                                        .font(.caption)
                                        .padding(8)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    
                                    Button("List All Models") {
                                        listAllModels()
                                    }
                                    .font(.caption)
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    
                                    Button("Clean View") {}
                                        .font(.caption)
                                        .padding(8)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        VStack {
                            HStack{
                                Spacer()
                                Image("goat")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Text("\(coinController.currentAmount)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                    }
                        .padding()
                    }

                    Spacer()
                }

                if isPlacingModel, tempDraggedEntity != nil {
                    VStack {
                        HStack(spacing: 20) {
                            Button {
                                print("Cancelled placement")
                                
                                DispatchQueue.main.async {
                                    if let entity = tempDraggedEntity {
                                        let uniqueID = entity.name
                                        do {
                                            if let modelToDelete = storedModels.first(where: { $0.uniqueID == uniqueID }) {
                                                coinController.addCoinToRealm(amount: costOfEachModel(name: modelToDelete.modelName))
                                                
                                                print("Deleting from database: \(modelToDelete.modelName) and the id \(modelToDelete.uniqueID)")
                                                modelContext.delete(modelToDelete)
                                                try modelContext.save()
                                            } else {
                                                print("Model not in database yet")
                                            }
                                        } catch {
                                            print("Database delete error: \(error)")
                                        }
                                        
                                        // STEP 2: Clean up tracking
                                        entityScaleMap.removeValue(forKey: entity.name)
                                    }
                                }
                                // STEP 3: CRITICAL - Force RealityView refresh to remove entity
                                refreshID = UUID()
                                
                                // STEP 4: Reset ALL state
                                DispatchQueue.main.async {
                                    tempDraggedEntity = nil
                                    tempModelEntity = nil
                                    draggedEntity = nil
                                    isPlacingModel = false
                                    isNewPlacement = false
                                    selectedModelName = nil
                                    selectedModelScale = nil
                                }
                                
                                print("Cancel complete - RealityView refreshed + DB cleaned")
                            } label: {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Cancel")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red.opacity(0.9))
                                .cornerRadius(16)
                            }

                            // Place Button (unchanged)
                            Button {
                                if let entity = tempDraggedEntity {
                                    if isNewPlacement {
                                        print("New Purchase")
                                        print("Selected Model Name is: \(selectedModelName ?? "nil")")
                                        if let modelName = selectedModelName {
                                            print("Model Name: \(modelName)")
                                            print("Model Position: \(entity.position)")
                                            print("Model Scale: \(selectedModelScale ?? 0.03)")
                                            print("Unique ID: \(entity.name)")

                                            DispatchQueue.main.async {
                                                let newModel = ModelStorage(
                                                    modelName: modelName,
                                                    uniqueID: entity.name,
                                                    modelXAxis: Float(entity.position.x),
                                                    modelYAxis: Float(entity.position.y),
                                                    modelZAxis: Float(entity.position.z),
                                                    modelScale: selectedModelScale ?? 0.03
                                                )
                                                coinController.deleteCoinFromRealm(amount: costOfEachModel(name: modelName))
                                                modelContext.insert(newModel)
                                                do {
                                                    try modelContext.save()
                                                } catch {
                                                    print("Error has occurred", error.localizedDescription)
                                                }
                                            }
                                        }
                                    } else {

                                        print("Updating existing model position")
                                        let uniqueID = entity.name
                                        do {
                                            if let existingModel = storedModels.first(where: { $0.uniqueID == uniqueID }) {
                                                existingModel.modelXAxis = Float(entity.position.x)
                                                existingModel.modelYAxis = Float(entity.position.y)
                                                existingModel.modelZAxis = Float(entity.position.z)
                                                try modelContext.save()
                                            } else {
                                                print("Could not find existing model with ID: \(uniqueID)")
                                            }
                                            print("Position update attempt finished")
                                        } catch {
                                            print("Error updating model position", error.localizedDescription)
                                        }
                                    }

                                    storeOriginalMaterials(entity: entity)
                                }

                                tempDraggedEntity = nil
                                tempModelEntity = nil
                                draggedEntity = nil
                                isPlacingModel = false
                                isNewPlacement = false
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Place")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green.opacity(0.9))
                                .cornerRadius(16)
                            }
                        }
                        .padding()

                        Spacer()
                    }
                    .allowsHitTesting(true)
                }

                // Model selection cards
                VStack {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            CardView(
                                cost: 10,
                                name: "Ringed Tree",
                                image: "TreeWithRings",
                                modelName: "HighPolyTree",
                                modelScale: 0.05,
                                selectedModelName: $selectedModelName,
                                selectedModelScale: $selectedModelScale,
                                isPlacingModel: $isPlacingModel,
                                isDisabled: isPlacingModel || coinController.currentAmount < 10,
                                onSelectNewModel: {
                                    isNewPlacement = true
                                }
                            )
                            CardView(
                                cost: 10,
                                name: "Terrian",
                                image: "Terrian",
                                modelName: "HighPolyTerrian",
                                modelScale: 0.06,
                                selectedModelName: $selectedModelName,
                                selectedModelScale: $selectedModelScale,
                                isPlacingModel: $isPlacingModel,
                                isDisabled: isPlacingModel || coinController.currentAmount < 10,
                                onSelectNewModel: {
                                    isNewPlacement = true
                                }
                            )
                            CardView(
                                cost: 10,
                                name: "Fern Tree",
                                image: "FernTree",
                                modelName: "HighPolyFernTree",
                                modelScale: 0.05,
                                selectedModelName: $selectedModelName,
                                selectedModelScale: $selectedModelScale,
                                isPlacingModel: $isPlacingModel,
                                isDisabled: isPlacingModel || coinController.currentAmount < 10,
                                onSelectNewModel: {
                                    isNewPlacement = true
                                }
                            )
                            CardView(
                                cost: 10,
                                name: "Bush",
                                image: "bush",
                                modelName: "bush",
                                modelScale: 0.09,
                                selectedModelName: $selectedModelName,
                                selectedModelScale: $selectedModelScale,
                                isPlacingModel: $isPlacingModel,
                                isDisabled: isPlacingModel || coinController.currentAmount < 10,
                                onSelectNewModel: {
                                    isNewPlacement = true
                                }
                            )

                            CardView(
                                cost: 10,
                                name: "Desert Branch",
                                image: "TreePreview",
                                modelName: "DesertBranch",
                                modelScale: 0.03,
                                selectedModelName: $selectedModelName,
                                selectedModelScale: $selectedModelScale,
                                isPlacingModel: $isPlacingModel,
                                isDisabled: isPlacingModel || coinController.currentAmount < 10,
                                onSelectNewModel: {
                                    isNewPlacement = true
                                }
                            )
                           
                                
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }

            // Drag gesture
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        if !isDragging {
                            let entity = value.entity
                            draggedEntity = entity
                            tempDraggedEntity = entity
                            dragStartPosition = entity.position
                            isDragging = true
                            isPlacingModel = true

                            // If this entity already exists in Realm, this is NOT a new placement
                            if storedModels.first(where: { $0.uniqueID == entity.name }) != nil {
                                isNewPlacement = false
                            }

                            print("Started dragging entity: \(entity.name)")
                            print(selectedModelName ?? "Not Found")
                            selectedModelScale = entityScaleMap[entity.name]
                        }

                        guard let entity = draggedEntity else { return }

                        let translation = value.translation
                        let xOffset = Float(translation.width) * 0.002
                        let yOffset = Float(-translation.height) * 0.002
                        let zOffset: Float = 0

                        entity.position = dragStartPosition + SIMD3(xOffset, yOffset, zOffset)
                    }
                    .onEnded { _ in
                        print("Ended drag")
                        draggedEntity = nil
                        isDragging = false
                    }
            )

            // Tap gesture
            .simultaneousGesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        let tappedEntity = value.entity
                        print("Tapped entity: \(tappedEntity.name)")
                        tempDraggedEntity = tappedEntity
                        draggedEntity = tappedEntity
                        dragStartPosition = tappedEntity.position
                        isPlacingModel = true
                        isNewPlacement = false
                        print(selectedModelName ?? "Not Found")
                    }
            )

            // Preload purchased model for NEW placements
            .task(id: isPlacingModel ? selectedModelName : nil) {
                if isPlacingModel,
                   isNewPlacement,
                   let modelName = selectedModelName {
                    print("Preloading model: \(modelName)")
                    
                    // Load USDZ model from Bundle
                    if let url = Bundle.main.url(forResource: modelName, withExtension: "usdz", subdirectory: "3D Models"),
                       let model = try? await ModelEntity(contentsOf: url) {
                        print("Model preloaded: \(modelName)")
                        await MainActor.run {
                            tempModelEntity = model
                            print("Model ready for placement: \(modelName)")
                        }
                    } else {
                        print("Failed to preload model: \(modelName)")
                    }
                } else {
                    await MainActor.run {
                        tempModelEntity = nil
                    }
                }
            }
        }
        .onAppear {
            print("🏝️ IslandView appeared")
 
        }
    }

    // MARK: - Helpers

    private func updateLiveData(currentTemp: Double) -> Double {
        return currentTemp
    }
    // make sure it correlates with the CardViewValues
    private func costOfEachModel(name: String) -> Int{
        switch name{
        case "HighPolyTree":
            return 10
        case "bush":
            return 10
        case "HighPolyTerrian":
            return 10
        case "DesertBranch":
            return 10
        case "HighPolyFernTree":
            return 10
        default:
            return 0
        }
    }
    private func listAllModels() {
        print("Total Model Count: \(storedModels.count)")
        for model in storedModels {
            print("Model UUID: \(model.uniqueID)")
            print("Model Name: \(model.modelName)")
            print("Position: (\(model.modelXAxis), \(model.modelYAxis), \(model.modelZAxis))")
            print("Scale: \(model.modelScale)")
        }
    }


    private func storeOriginalMaterials(entity: Entity) {
        traverseHierarchy(entity) { child in
            if var modelComponent = child.components[ModelComponent.self] {
                if child.components[OriginalMaterialsComponent.self] == nil {
                    let originalMaterials = modelComponent.materials
                    child.components.set(OriginalMaterialsComponent(materials: originalMaterials))
                }
            }
        }
    }

    private func applyHolographicMaterial(to entity: Entity, touching: Bool) {
        traverseHierarchy(entity) { child in
            if var modelComponent = child.components[ModelComponent.self] {
                var holographicMaterial = UnlitMaterial()
                holographicMaterial.color = .init(tint: .cyan.withAlphaComponent(0.05))
                modelComponent.materials = modelComponent.materials.map { _ in holographicMaterial }
                child.components.set(modelComponent)
            }
        }
    }

    private func restoreOriginalMaterials(entity: Entity) {
        traverseHierarchy(entity) { child in
            if var modelComponent = child.components[ModelComponent.self],
               let originalComponent = child.components[OriginalMaterialsComponent.self] {
                modelComponent.materials = originalComponent.materials
                child.components.set(modelComponent)
            }
        }
    }

    private func traverseHierarchy(_ entity: Entity, perform action: (Entity) -> Void) {
        action(entity)
        for child in entity.children {
            traverseHierarchy(child, perform: action)
        }
    }
}

// Component to store original materials
struct OriginalMaterialsComponent: Component {
    var materials: [RealityKit.Material]
}

// CardView with callback to mark new placements
struct CardView: View {
    @State var cost: Int
    @State var name: String
    @State var image: String
    @State var modelName: String
    var modelScale: Float
    @Binding var selectedModelName: String?
    @Binding var selectedModelScale: Float?
    @Binding var isPlacingModel: Bool
    var isDisabled: Bool = false
    // Called when a new model is selected
    var onSelectNewModel: (() -> Void)?
  
    var body: some View {
        Rectangle()
            .frame(width: 150, height: 200)
            .cornerRadius(12)
            .foregroundStyle(.white.opacity(0.5))
            .overlay {
                VStack {
                    Image("\(image)")
                        .resizable()
                        .frame(width: 100, height: 100)
                  
                    Text("\(name)")
 
                    Button {
                        
                        if !isDisabled {
                            print("🛒 Selected model: \(name) with scale: \(modelScale)")
                            selectedModelName = modelName
                            selectedModelScale = modelScale
                            isPlacingModel = true
                            
                            onSelectNewModel?()
                        }
                    } label: {
                        HStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 100, height: 25)
                                .foregroundStyle(isDisabled ? Color.gray : Color.blue)
                                .overlay {
                                    HStack {
                                        Image("goat")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        Text("\(cost)")
                                            .fontWeight(.medium)
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                    }
                                }
                        }
                    }
                    .disabled(isDisabled)
                    .opacity(isDisabled ? 0.5 : 1.0)
                }
            }
    }
}

#Preview {
    IslandView()
}
