//
//  Page2.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct Page2: View {
    var body: some View {
        ZStack{
            ColorScheme()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .foregroundStyle(Gradient(colors: [.yellow]))
                    .frame(width: 50, height: 50)
                Text("Tasks")
                    .foregroundStyle(Color(.white))
                    .bold()
                    .font(.title)
                Text("Complete tasks to gain coins, and use coins to build your own virtual island.")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: min(UIScreen.main.bounds.width * 0.7, 600))
                    .padding()
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}

#Preview {
    Page2()
}
