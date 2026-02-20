//
//  Page3.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct Page3: View {
    var body: some View {
        ZStack{
            ColorScheme()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image(systemName: "snowflake")
                    .resizable()
                    .foregroundStyle(Gradient(colors: [.yellow]))
                    .bold()
                    .frame(width: 50, height: 50)
                Text("AR Intergration")
                    .foregroundStyle(Color(.white))
                    .bold()
                    .font(.title)
                Text("Place your virtual island in the real world through AR Integration. It is as easy as clicking the blue button on the bottom. Then tapping on a flat surface, and clicking the green button stating place here.")
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
    Page3()
}
