//
//  ColorScheme.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/5/25.
//






import SwiftUI
import SwiftData
import FoundationModels

struct ContentView: View {
    @State private var stringUsed = ""
    private var finalString = "Welcome to EcoHelp"
    @State private var charactherIndex: Int = 0
    @State private var goUp = false
    @State private var showNextAttribute = false
    @State private var goToNextPage = false
    @State private var generatedText = ""
    @State private var textGenReady = false
    var body: some View {
        NavigationStack {
            ZStack {
                ColorScheme()
                VStack(spacing: 2) {
                    Text(stringUsed)
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.title)
                        .onAppear { textTypingAnimation() }
                        .offset(y: goUp ? -150 : 0)
                        .overlay{
                            
                            if textGenReady == true{
                                VStack{
                                    
                                    
                                    Text(generatedText)
                                        .padding(.bottom, 100)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .bold()
                                }
                            }
                        }
                    
                    
                    
                    if showNextAttribute {
                        
                        Image("SwiftInterntionImage-removebg-preview 1")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding()
                        
                        
                        NavigationLink(destination: CountryChosenView(), isActive: $goToNextPage) {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.white)
                                .frame(width: 300, height: 50)
                                .overlay {
                                    Text("Get Started")
                                        .foregroundStyle(.black)
                                }
                        }
                        .buttonStyle(.plain)
                        
                        
                    }
                    
                }
                .padding()
                
            }
            .preferredColorScheme(.dark)
        }
        
    }
    
    
    func startTextGen() {
        generatedText = "The greatest threat to our planet is the belief that someone else will save it. — Robert Swan"
        showNextAttribute = true
        if #available(iOS 26.0, *) {
            Task {
                do {
                    let modelSession = LanguageModelSession(instructions: "Generate daily quotes that are positive and relate to climate change make it as inspiring as possible while keeping it under 20 words, and make it motivational. Only generate 1 quote no more/less AND NO EMOJIS, add quotation marks in the beginning and end of quote")
                    let stream = modelSession.streamResponse(to: "Create inspiring quotes to help people do something for climate change, make them feel inspired JUST THE QUOTE")
                    for try await partial in stream {
                        await MainActor.run {
                            generatedText = partial.content
                        }
                    }
                } catch {
                    print("Streaming failed:", error.localizedDescription)
                }
            }
        }
    }
    func textTypingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if charactherIndex < finalString.count {
                let index = finalString.index(finalString.startIndex, offsetBy: charactherIndex)
                stringUsed.append(finalString[index])
                charactherIndex += 1
            } else {
                timer.invalidate()
                withAnimation(.smooth(duration: 3.0)) {
                    goUp = true
                }
                textGenReady = true
                startTextGen()
            }
            
            
            
        }
    }
}




#Preview {
    ContentView()
}
