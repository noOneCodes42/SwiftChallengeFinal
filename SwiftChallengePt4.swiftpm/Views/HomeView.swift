//
// HomeView.swift
// Swift International Challenge P1
//
// Created by Neel Arora on 8/11/25.
//


import SwiftUI
import SwiftData
import RealityKit
import FoundationModels

struct DailyFootprint: Identifiable {
    let id = UUID()
    let day: Int
    let userValue: Double
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var countryController = RealmViewController()
    @Environment(CoinViewController.self) private var coinController
    @Environment(\.dismiss) var dismiss
    @Environment(CarbonEmissionDailyController.self) private var dailyController

    @State private var currentUserY: Double?
    @State private var currentEarthModelName: String = ""
    @State private var generatedText = ""
    @State private var modelEntity: ModelEntity?
    @State private var anchorEntity: AnchorEntity?

    @State private var showLayerInfo = false
    @State private var showCoinsConversion = false
    @State private var calendarController = CalendarController()
    @State private var sheetPresented = false
    @State private var modelSession = LanguageModelSession(
        instructions: """
        Generate daily quotes that are positive and relate to climate change.
        Keep under 20 words.
        Motivational.
        Only generate 1 quote.
        Add quotation marks.
        NO EMOJIS.
        """
    )
    // MARK: - Computed Properties

    var countryAverage: Double {
        countryCarbonEmission.first {
            $0.countryName == countryController.nameOfCountry()
        }?.avgAmountOfCarbonEmissions ?? 10.0
    }

    var currentFootprint: Double {
        max(countryAverage / 365 - (dailyController.amount / 10000.0), 0)
    }

    var nextLayerCoin: String {
        let current = currentFootprint
        let coinsPerTon: Double = 10000.0
        var tonsNeeded: Double = 0

        if current > 0.03 {
            tonsNeeded = current - 0.03
        } else if current > 0.01 {
            tonsNeeded = current - 0.01
        } else {
            tonsNeeded = 0
        }

        let coinsNeeded = tonsNeeded * coinsPerTon
        return String(format: "%.0f", coinsNeeded)
    }

    var nextLayerText: String {
        let current = currentFootprint
        switch true {
        case current < 0.01:
            return "Pollution Averted"
        case current < 0.02:
            return "\(String(format: "%.3f", current - 0.01)) tons"
        case current < 0.03:
            return "\(String(format: "%.3f", current - 0.02)) tons"
        default:
            return "\(String(format: "%.3f", current - 0.03)) tons"
        }
    }

    var currentFootprintColor: Color {
        if currentFootprint < 0.01 {
            return .green
        } else if currentFootprint < 0.02 {
            return .yellow
        } else if currentFootprint < 0.03 {
            return .orange
        } else {
            return .red
        }
    }


    var body: some View {
        ZStack {
            ColorScheme()
                .ignoresSafeArea()

            RealityView { content in
                let anchor = AnchorEntity()
                content.add(anchor)
                anchorEntity = anchor
                loadEarthModelSync(anchor: anchor)
            } update: { content in
                if let existingAnchor = anchorEntity ??
                    (content.entities.first(where: { $0 is AnchorEntity }) as? AnchorEntity) {
                    anchorEntity = existingAnchor
                    loadEarthModelSync(anchor: existingAnchor)
                }
            }


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
                .padding()

                Text("Amount of Carbon Saved")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()

                Text("\(dailyController.amount / 10000.0, specifier: "%.2f") tons")
                    .foregroundStyle(.indigo)
                    .font(.title2)
                    .bold()

                Spacer()

                Text(generatedText.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.15))
                    )
                    .shadow(radius: 10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 100)
            }

            VStack(alignment: .leading) {
                HStack {
                    Button {
                        showLayerInfo = true
                        showCoinsConversion = false
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.9))
                                .frame(width: 30, height: 30)
                                .shadow(radius: 8)
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.white)
                                .font(.subheadline)
                            
                        }
                    }

                    Spacer()
                }
                Spacer()
            }
            .padding()

//            VStack {
//                Spacer()
//                HStack {
//                    Button {
//                        sheetPresented = true
//                    } label: {
//                        Image(systemName: "calendar")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(12)
//                            .background(Circle().fill(Color.green.opacity(0.85)))
//                            .shadow(radius: 6)
//                    }
//                    .padding(.leading, 30)
//
//                    Spacer()
//                }
//                .padding(.bottom, 40)
//            }
        }
        .onTapGesture {
            dismiss()
        }
        .onChange(of: dailyController.amount) { _, _ in
            updateCoinPoint()
            calendarController.addData(
                name: currentEarthModelName,
                saved: dailyController.amount / 10000.0,
                on: Date()
            )
        }
        .sheet(isPresented: $sheetPresented) {
            CalendarView()
        }
        .onAppear {
            countryController.setModelContext(modelContext)
            calendarController.setModelContext(modelContext)
            calendarController.addData(
                name: currentEarthModelName,
                saved: dailyController.amount / 10000.0,
                on: Date()
            )
            updateCoinPoint()
            startTextGen()
        }
        .sheet(isPresented: $showLayerInfo){
            ZStack{
                ColorScheme()

                    VStack(spacing: 12) {
                        Text("Next Layer Progress")
                            .font(.title)
                            .foregroundColor(.white)
                        Button {
                            withAnimation(.easeInOut) {
                                showCoinsConversion.toggle()
                            }
                        } label: {
                            if showCoinsConversion {
                                Text("\(nextLayerCoin) Coins Needed")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.yellow)
                            } else {
                                if nextLayerText == "Pollution Averted" {
                                    Text("0.00 tons")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.green)
                                } else {
                                    Text(nextLayerText)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(currentFootprintColor)
                                }
                            }
                        }
                        Text("Tap number to convert")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(18)
                
            }
            .presentationDetents([.medium])
        }

    }

    // MARK: - AI Quote (unchanged)

    func startTextGen() {
        generatedText = ""
        if #available(iOS 26.0, *) {
            Task {
                do {
                    let stream = modelSession.streamResponse(to: "Create one inspiring climate quote.")
                    for try await partial in stream {
                        await MainActor.run {
                            generatedText = partial.content
                        }
                    }
                } catch {
                    print("Streaming failed:", error.localizedDescription)
                    generatedText = "Every day is an opportunity to make our planet healthier."
                }
            }
        } else {
            generatedText = "Every day is an opportunity to make our planet healthier."
        }
    }


    private func loadEarthModelSync(anchor: AnchorEntity) {
        Task { @MainActor in
            await loadEarthModel(anchor: anchor)
        }
    }

    @MainActor
    private func loadEarthModel(anchor: AnchorEntity) async {
        anchor.children.removeAll()

        do {
            var url: URL?
            url = Bundle.main.url(forResource: currentEarthModelName, withExtension: "usdz", subdirectory: "3D Models")
            
            if url == nil {
                url = Bundle.main.url(forResource: currentEarthModelName, withExtension: "usdz")
            }
            
            if url == nil {
                let path = "3D Models/\(currentEarthModelName).usdz"
                url = Bundle.main.url(forResource: path, withExtension: nil)
            }
            
            guard let finalURL = url else {
                print("Could not find \(currentEarthModelName).usdz in Bundle")
                print("Tried subdirectory: 3D Models")
                print("Bundle path: \(Bundle.main.bundlePath)")
                

                if let resourcePath = Bundle.main.resourcePath {
                    print("Resource path: \(resourcePath)")
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                        print("Bundle contents: \(contents.prefix(10).joined(separator: ", "))")
                        
                        let modelsPath = (resourcePath as NSString).appendingPathComponent("3D Models")
                        if FileManager.default.fileExists(atPath: modelsPath) {
                            let modelContents = try FileManager.default.contentsOfDirectory(atPath: modelsPath)
                            print("3D Models folder contents: \(modelContents.joined(separator: ", "))")
                        }
                    } catch {
                        print("Could not list bundle contents: \(error)")
                    }
                }
                return
            }
            
            print("Found model at: \(finalURL.path)")
            
            let model = try await ModelEntity(contentsOf: finalURL)
            
            model.generateCollisionShapes(recursive: true)
            model.components.set(InputTargetComponent())
            model.position = [0, 0, -0.5]
            model.scale = [0.6, 0.6, 0.6]
            anchor.addChild(model)

            Task.detached {
                await spinForEver(model: model)
            }
        } catch {
            print("Failed to load model \(currentEarthModelName):", error)
        }
    }

    func spinForEver(model: ModelEntity) async {
        while true {
            let q = simd_quatf(angle: -0.01, axis: SIMD3<Float>(0, 1, 0))
            model.transform.rotation = q * model.transform.rotation
            try? await Task.sleep(nanoseconds: 16_000_000)
        }
    }


    private func updateCoinPoint() {
        let offset = dailyController.amount / 10000.0
        let mappedY = max((countryAverage / 365) - offset, 0)
        currentUserY = mappedY

        if mappedY > 0.03 {
            currentEarthModelName = "earth_intense"
        } else if mappedY > 0.01 {
            currentEarthModelName = "earth_mid_intense"
        } else {
            currentEarthModelName = "earth"
        }
    }
}


#Preview {
    HomeView()
}
