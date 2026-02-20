//
//  StatisticsView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ColorScheme()
                
                VStack(spacing: 20) {
                    Text("Statistics")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                    
                    List {
                        NavigationLink {
                            CountryAverageView()
                        } label: {
                            HStack {
                                Text("Country Average")

                            }
                        }
                        
                        NavigationLink {
                            TotalCarbonSavedView()
                        } label: {
                            HStack {
                                Text("Total Carbon Saved")
                               
                            }
                        }
                        
                        NavigationLink {
                            TotalCoinsMadeView()
                        } label: {
                            HStack {
                                Text("Total Coins Made")
  
                            }
                        }
                    }
                    .frame(height: 200)
                    .padding(.bottom, 200)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.clear)  // Keeps background transparent
                }
            }
        }
    }
}






#Preview {
    StatisticsView()
}
