//
//  Page4.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct Page4: View {
    var body: some View {
        ZStack{
            ColorScheme()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image(systemName: "globe")
                    .resizable()
                    .foregroundStyle(Gradient(colors: [.yellow]))
                    .bold()
                    .frame(width: 50, height: 50)
                Text("Clean Earth")
                    .foregroundStyle(Color(.white))
                    .bold()
                    .font(.title)
                Text("More tasks = Cleaner Earth. Earth starts as a red globe but slowly becomes blue as you do more tasks. Click on leaf icon to see how far you are from the next layer.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: min(UIScreen.main.bounds.width * 0.7, 600))
                    .foregroundStyle(.white)
                    .bold()
            }
        }
        
    }
}

#Preview {
    Page4()
}
