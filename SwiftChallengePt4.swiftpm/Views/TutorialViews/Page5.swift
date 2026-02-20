//
//  Page5.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI
import SwiftData

struct Page5: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tutorialController = TutorialController()
    
    var body: some View {
        ZStack{
            ColorScheme()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(Gradient(colors: [.yellow]))
                    .bold()
                    .frame(width: 50, height: 50)
                Text("Ready to begin")
                    .foregroundStyle(Color(.white))
                    .bold()
                    .font(.title)
                Text("Now you are ready for an easier and exciting way to reduce carbon footprint.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(.white)
                    .bold()
                    .frame(maxWidth: min(UIScreen.main.bounds.width * 0.7, 600))
                    Button {
                        tutorialController.setModelContext(modelContext)
                        tutorialController.addValue()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 300, height: 50)
                            .overlay{
                                Text("Start")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                        
                    }
                    
                
            }
        }
    }
}

#Preview {
    Page5()
}
