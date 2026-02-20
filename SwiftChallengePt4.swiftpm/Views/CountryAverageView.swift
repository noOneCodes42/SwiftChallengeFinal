//
//  CountryAverageView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI
import SwiftData

struct CountryAverageView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var countryController = RealmViewController()
    
    var countryAverage: Double {
        countryCarbonEmission.first {
            $0.countryName == countryController.nameOfCountry()
        }?.avgAmountOfCarbonEmissions ?? 10.0
    }
    
    var body: some View {
        ZStack {
            ColorScheme()
            
            VStack(spacing: 30) {
                
                Text("Country Average Emissions")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                VStack(spacing: 16) {
                    
                    Text(countryController.nameOfCountry())
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("\(String(format: "%.2f", countryAverage))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("tons per person / year")
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
        .task {
            countryController.setModelContext(modelContext)
        }
    }
}


#Preview {
    CountryAverageView()
}
