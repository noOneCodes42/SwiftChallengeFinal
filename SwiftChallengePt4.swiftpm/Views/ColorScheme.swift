//
//  ColorScheme.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/6/25.
//

import SwiftUI

struct ColorScheme: View {
    var limeGreen = Color(red: 0.1803921568627451, green: 0.7490196078431373, blue: 0.5686274509803921   )
    var paleGreen = Color(red: 0.5764705882352941, green: 0.9764705882352941, blue: 0.7254901960784313)
    var body: some View {
        LinearGradient(colors: [limeGreen, paleGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

#Preview {
    ColorScheme()
}
