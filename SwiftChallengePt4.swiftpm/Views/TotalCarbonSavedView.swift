//
//  TotalCarbonSavedView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct TotalCarbonSavedView: View {
    @Environment(CarbonFootPrintSavedController.self) private var carbonFootPrint
    
    var body: some View {
        ZStack {
            ColorScheme()
            
            VStack(spacing: 30) {
                
                Text("Total Carbon Saved")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                VStack(spacing: 16) {
                    
                    Text("\(String(format: "%.2f", carbonFootPrint.carbonFootPrintSaved / 10000.0))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("tons of CO₂ reduced")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


#Preview {
    TotalCarbonSavedView()
}
