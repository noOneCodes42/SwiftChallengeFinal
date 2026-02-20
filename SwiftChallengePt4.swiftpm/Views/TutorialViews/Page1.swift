//
//  Page1.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct Page1: View {
    var body: some View{
        ZStack{
            ColorScheme()
            VStack{
                Image(systemName: "leaf")
                    .font(.custom("Arial", size: 50))
                    .foregroundStyle(Gradient(colors: [.yellow, .green, .blue]))
                Text("Welcome to EcoHelp")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .padding()
                Text("An easier way to save the earth we all adore")
                    .foregroundStyle(Color(.white))
                    .frame(maxWidth: min(UIScreen.main.bounds.width * 0.7, 600))
                    .bold()
            }
        }
        
    }
}

#Preview {
    Page1()
}
