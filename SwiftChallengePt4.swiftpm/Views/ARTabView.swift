//
//  ARVTabiew.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/13/26.
//

import SwiftUI
import ARKit
import SceneKit
import SwiftData

// MARK: - CoordinatesARView

struct CoordinatesARView: UIViewRepresentable {
    @Binding var showPlane: Bool // first binding var to see if I wanna show plane
    @Binding var isPlacing: Bool // see if it is in placing mode
 
    var points: [SavedPoint] // getting a list of my SavedData model
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero) // create an 0,0,0 frame doesnt really matter but needs to be init to get the plane tracking
        view.delegate = context.coordinator // letting the view.delegate equal to the contxt coordinator basically the bridge between my swift logic and arscn stuff
        view.session.delegate = context.coordinator // same thing here
        view.automaticallyUpdatesLighting = true // live light updating in the ARView
        view.scene = SCNScene() // creating a scene and making it equal to the view.scene which is the ARCSCNView, so basically making an blank scene
        
        context.coordinator.points = points // makeCoordinator allows me to do context.coordinator and have the properties of the class returned which is why I am able to this
        context.coordinator.arView = view // same thing over here

        let config = ARWorldTrackingConfiguration() // my ARWorldTracking Configs.
        config.planeDetection = [.horizontal] // detecting horizontal planes
        config.environmentTexturing = .automatic // automatically retexturing the models as needed
        view.session.run(config, options: [.resetTracking, .removeExistingAnchors]) // running the session with the configuration and reseting the scene so it is basically brand new

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        ) // defining a UITapGestureRecognizer the target being my Coordinator class that is linked to context.coordinator and then the action which #selector basically allows me to access my obj-c handle tap property
        view.addGestureRecognizer(tapGesture) // adds a gesture recognizer for the tap gesture

        let panGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:))
        ) // same thing over here
        view.addGestureRecognizer(panGesture) // here as well

        return view // just returning the view that has allt the properties I need for app tow ork
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let coordinator = context.coordinator // making the an instance of the coordinator

        
        coordinator.points = points // letting the coordinator have the live positions which is important for the moving of the plane
        
//        // Only update models if we're NOT actively placing (prevents conflicts)
        if !isPlacing && coordinator.planeNode != nil { // if it is not editing view and the plane is placed
            coordinator.updateModelsEfficiently(newPoints: points) // constantly checking for updates in the database and updating the reality view accordingly
        }
        
        let oldIsPlacing = coordinator.isPlacing
    

        coordinator.isPlacing = isPlacing
        coordinator.showPlane = showPlane

        if oldIsPlacing && !isPlacing && !showPlane { // if user clicks cancel then it clearIsland()
            coordinator.clearIsland()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self) // making the Coordinator self for the CoordinatesARView
        
    }

    class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: CoordinatesARView
        @State var deletedModels = []
        var points: [SavedPoint] = []
        weak var arView: ARSCNView?

        var planeNode: SCNNode?
        var modelNodes: [SCNNode] = []
        
        private var modelCount = 0
        var showPlane = false
        var isPlacing = false

        init(_ parent: CoordinatesARView) {
            self.parent = parent // initializing the parent
        }
        
            
            
        // MARK: - Gestures

        @MainActor
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARSCNView else { return }
            let tapLocation = gesture.location(in: arView) // Gets the location tapped on

            // If NOT placing and tap on existing plane, enter edit mode
            if !isPlacing {
                guard let planeNode = planeNode else { return } // making sure that planeNode exists
                let nodeHits = arView.hitTest(tapLocation, options: nil) // getting the models that the user tapped on
                if nodeHits.contains(where: { $0.node == planeNode || $0.node.parent == planeNode }) { // makes sure what is being tapped is corelated to the planeNode
                    isPlacing = true // displays isPlacing UI
                    parent.isPlacing = true // tells the CoordinateARView that placing is going to happen
                    return
                }
                return
            }

            // In placement mode: tap surface to place/move island
            let results = arView.hitTest(tapLocation, types: [.existingPlaneUsingExtent]) // makes sure what is being tapped on is a plane
            guard let hit = results.first else { return } // if it is then lets it place on the first result otherwise it pauses

            if planeNode == nil { // checks if plane node is non existant
                createPlaneIfNeeded(at: hit) // if it is than it creates it at that location
                placeModelsOnPlane() // loads the database on top of the model
                parent.showPlane = true // allows the RealityView to show it on the scene
                showPlane = true // showPlane for this class is allowed as well
            } else {
                movePlaneToHit(hit) // otherwise it just updates the plane position
                updateModelsRelativeToPlane() // along with the model positions
            }
        }

        @MainActor
        @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            guard isPlacing, let arView = arView else { return }
            let location = sender.location(in: arView) // getting the x,y the user click on in the ARView

            switch sender.state {
            case .began: // if the user tapped the screen
                guard let planeNode = planeNode else { return } // if plane node exists
                let hits = arView.hitTest(location, options: nil) // checks the models my finger have tapped on
                if !hits.contains(where: { $0.node == planeNode || $0.node.parent == planeNode }) { // checks that what I am tapping is apart of the plane or a child of the plane
                    return
                }
            case .changed:
                guard planeNode != nil else { return }
                let results = arView.hitTest(location, types: [.existingPlaneUsingExtent]) // checks the plane I have tapped on
                guard let hit = results.first else { return } // makes sure that the plane exists before moving it
                movePlaneToHit(hit) // the move plane code
                updateModelsRelativeToPlane() // the model code
            default:
                break
            }
        }


        func updateModelsEfficiently(newPoints: [SavedPoint]) {
            guard let planeNode = planeNode, let arView = arView else { return }

           
            let newByID = Dictionary(uniqueKeysWithValues: newPoints.map { ($0.id, $0) }) // looping over newPOints and creating a dictionary with the id and index
            let newIDs = Set(newByID.keys) // creates a set if the dictionary for easy access

            modelNodes = modelNodes.filter { node in // filtering the model nodes to delete the models not in the database anymore
                print("Entered The Filter Area")

             
                guard let name = node.name,
                      let idPart = name.split(separator: "_").last else {
                    node.removeFromParentNode()
                    return false
                } // splits all the nodes name to contain the ID

                let nodeID = String(idPart) // stringifying the ID for saftey
                let shouldKeep = newIDs.contains(nodeID) // checking if the nodeID is still in the database

                if !shouldKeep {
                    print("Removing node with id \(nodeID)") // if not then removes the node
                    node.removeFromParentNode()
                }
                
                return shouldKeep // if it does exist return it back
            }

         
            for point in newPoints { // loops constantly to check if the node contains all the models, and if it doesn't it adds them
                let nodeName = "model_\(point.id)"
                let alreadyExists = modelNodes.contains { $0.name == nodeName } // checking if it is existant
                if !alreadyExists {
                    addSingleModel(point: point) // the actually adding of the model part
                }
            }

            
            for node in modelNodes { // looping over all the ndoes
                guard let name = node.name,
                      let idPart = name.split(separator: "_").last else { continue } // splitting the node or continuing if doesn't exist

                let nodeID = String(idPart) // stringify the id
                guard let point = newByID[nodeID] else { continue } // loops over the ids to make sure it all exists if it doesn't then it just moves on

                updateModelPosition(node, point: point) // it then updates the locaiton of the model as currently it is just added in the scene hasn'st actually been moved
            }

            print("Synced \(newPoints.count) models by uniqueID")
        }



        private func addSingleModel(point: SavedPoint) {
            guard let planeNode = planeNode, let arView = arView else { return }

            // Load USDZ model from Bundle
            guard let url = Bundle.main.url(forResource: point.modelName, withExtension: "usdz", subdirectory: "3D Models") else {
                print("Couldn't find \(point.modelName).usdz in Bundle")
                return
            }
            
            guard let scene = try? SCNScene(url: url, options: nil) else {
                print("Couldn't load scene from: \(url.lastPathComponent)")
                return
            }

            let container = SCNNode()
            container.name = "model_\(point.id)" // adding the id so you can tell what it is

           
            for child in scene.rootNode.childNodes {
                container.addChildNode(child.clone()) // add all the child nodes by cloning them in
            }

            // Stand upright
            container.eulerAngles.x = -.pi / 2

            // Position relative to plane
            let modelX = planeNode.worldPosition.x + point.x // placement relative to plane
            let modelZ = planeNode.worldPosition.z + point.z // placement relative to plane
            let modelY = planeNode.worldPosition.y + point.y // placement relative to plane

            container.position = SCNVector3(modelX, modelY, modelZ)
            container.scale = SCNVector3(point.scale, point.scale, point.scale)

            arView.scene.rootNode.addChildNode(container)
            modelNodes.append(container) // add it to the model nodes so it actually pops up

            print("Added \(point.modelName).usdz for id \(point.id)")
        }


        private func updateModelPosition(_ container: SCNNode, point: SavedPoint) {
            guard let planeNode = planeNode else { return }

            let modelX = planeNode.worldPosition.x + point.x // updating the model position based off of the plane position
            let modelZ = planeNode.worldPosition.z + point.z // updating the model position based off of the plane position
            let modelY = planeNode.worldPosition.y + point.y // updating the model position based off of the plane position

            container.position = SCNVector3(modelX, modelY, modelZ) // updating the container
            container.scale = SCNVector3(point.scale, point.scale, point.scale)// updating the container
        }

        // MARK: - Plane detection

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            print("Plane detected! Size: \(planeAnchor.extent.x) x \(planeAnchor.extent.z)")

            // Semi-transparent plane to show detected surfaces
            let plane = SCNPlane(
                width: CGFloat(planeAnchor.extent.x),
                height: CGFloat(planeAnchor.extent.z)
            ) // specifying the size of the plane
            let material = SCNMaterial() // the material used
            
            // Make plane slightly visible so users can see detected surfaces
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.3) // semi-transparent white
            plane.materials = [material] // the materials used

            let planeNode = SCNNode(geometry: plane) // creating the node for the model so it can actually show up
            planeNode.eulerAngles.x = -.pi / 2 // makes the plane flat on the ground
            planeNode.position = SCNVector3(
                planeAnchor.center.x,
                planeAnchor.center.y,
                planeAnchor.center.z
            ) // the position is based off of the center of the ARPlaneAnchor instance we made above
            planeNode.name = "DetectedPlane" // the name of the plane
            planeNode.opacity = 0.5 // make it semi-transparent

            node.addChildNode(planeNode) // adding it as a childNode so it can actually be used

            if self.planeNode == nil {
                self.planeNode = planeNode // making sure that planeNode global is equal to the plane node we made here
            }
        }
        
        // Update detected planes as ARKit refines them
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // Update the plane size as ARKit refines detection
            for childNode in node.childNodes {
                if childNode.name == "DetectedPlane", let plane = childNode.geometry as? SCNPlane {
                    plane.width = CGFloat(planeAnchor.extent.x)
                    plane.height = CGFloat(planeAnchor.extent.z)
                    childNode.position = SCNVector3(
                        planeAnchor.center.x,
                        planeAnchor.center.y,
                        planeAnchor.center.z
                    )
                    print("Plane updated: \(planeAnchor.extent.x) x \(planeAnchor.extent.z)")
                }
            }
        }

        private func createPlaneIfNeeded(at hit: ARHitTestResult) {
            if let existingPlane = planeNode { // if there is a plane
                
                existingPlane.geometry = SCNPlane(width: 0.5, height: 0.5) // specify the size of the plane which is 0.5, 0.5
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.brown // to get that dirt feel
                existingPlane.geometry?.materials = [material] // the material
                existingPlane.opacity = 1.0 // make it fully visible when placed
                existingPlane.name = "Dirt" // rename to Dirt when placed
                movePlaneToHit(hit)
                print("Island placed on detected plane")
                return
            }

           
            let plane = SCNPlane(width: 0.5, height: 0.5) // incase there isn't a plane already
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.brown
            plane.materials = [material]

            let node = SCNNode(geometry: plane)
            node.eulerAngles.x = -.pi / 2
            let t = hit.worldTransform // getting the 4x4 matrix needed for the worldPosition
            node.worldPosition = SCNVector3( // getting the third column in the matrix which consists of the matrix needed for the position, as the others are for the direction
                t.columns.3.x,
                t.columns.3.y,
                t.columns.3.z
            )
            node.name = "Dirt" // naming the node
            node.opacity = 1.0 // fully visible

            arView?.scene.rootNode.addChildNode(node) // adding another childNode
            planeNode = node // making the global planeNode to this so that it shows this
            print("New island plane created")
        }

        private func movePlaneToHit(_ hit: ARHitTestResult) {
            guard let planeNode = planeNode else { return }
            let t = hit.worldTransform // 4x4 matrix again
            planeNode.worldPosition = SCNVector3( // when dirt is tapped again then it updates the planeNode location as the user moves it around
                t.columns.3.x,
                t.columns.3.y,
                t.columns.3.z
            )
        }

        // MARK: - Models (Initial Placement)

        private func placeModelsOnPlane() {
            guard let planeNode = planeNode, let arView = arView else { return }

            // Clear existing models but keep plane
            clearModelsOnly()

            // Add all current models
            for (index, point) in points.enumerated() { // the code that actually places the models that are in the database
                addSingleModel(point: point)
            }
        }

        private func updateModelsRelativeToPlane() {
            guard let planeNode = planeNode else { return }

            for (index, point) in points.enumerated() {
                guard index < modelNodes.count else { continue } // looping over the nodes
                let container = modelNodes[index] // having a container for each node at x index

                let modelX = planeNode.worldPosition.x + point.x // the way that the models stay relative of the plane
                let modelZ = planeNode.worldPosition.z + point.z // the way that the models stay relative of the plane
                let modelY = planeNode.worldPosition.y + point.y // the way that the models stay relative of the plane

                container.position = SCNVector3(modelX, modelY, modelZ) // updating the container position
            }
        }

        private func clearModelsOnly() {
            for node in modelNodes {
                node.removeFromParentNode()
            }
            modelNodes.removeAll()
            // clears all the models currently loaded on the plane
        }

        // MARK: - Clear island

        func clearIsland() {
            // clear everything including the plane
            planeNode?.removeFromParentNode()
            planeNode = nil
            clearModelsOnly()
        }

    }

}


// MARK: - ARTabView
struct ARTabView: View {
    @State private var showPlane = false
    @State private var isPlacing = false
    @Query private var storedModels: [ModelStorage]
    
    var scale: [String: Float] = [
        "HighPolyTree": 0.008,
        "HighPolyFernTree": 0.01,
        "HighPolyTerrian": 0.01,
        "bush": 0.02,
        "DesertBranch": 0.008
    ]
    
    var yAxisOffset: [String: Float] = [
        "HighPolyTree": 0.2,
        "HighPolyFernTree": 0.15,
        "HighPolyTerrian": 0.1,
        "bush": 0.001,
        "DesertBranch": 0.067
    ]

    var allSavedPoints: [SavedPoint] {
        Array(storedModels.map { model in
            SavedPoint(
                x: model.modelXAxis*0.1,
                y: model.modelZAxis*(yAxisOffset[model.modelName] ?? 0.001),
                z: model.modelYAxis*0.2,
                modelName: model.modelName,
                scale: scale[model.modelName] ?? 0.0,
                id: model.uniqueID
            )
        })
    }

    var body: some View {
        ZStack {
            CoordinatesARView(
                showPlane: $showPlane,
                isPlacing: $isPlacing,
                points: allSavedPoints
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                if isPlacing {
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            isPlacing = false
                            showPlane = false
                        }
                        .padding()
                        .background(.red.opacity(0.9))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button("Place Here") {
                            isPlacing = false
                        }
                        .padding()
                        .background(.green.opacity(0.9))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.bottom)
                } else {
                    Button("Tap Surface → Start Placement") {
                        if !showPlane {
                            isPlacing = true
                            showPlane = true
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ARTabView()
}

