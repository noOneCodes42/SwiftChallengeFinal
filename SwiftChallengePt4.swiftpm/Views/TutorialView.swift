//
//  TutorialView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct TutorialView: View {
    @State private var selectedTab = 0
    var body: some View {
        ZStack{
            ColorScheme()
            TabView(selection: $selectedTab){
                Page1()
                    .tag(0)
                Page2()
                    .tag(1)
                Page3()
                    .tag(2)
                Page4()
                    .tag(3)
                Page5()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

#Preview {
    TutorialView()
}
