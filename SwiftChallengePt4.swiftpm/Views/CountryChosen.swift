//
//  CountryChosen.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/11/25.
//

import SwiftUI
import SwiftData

struct CountryChosenView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showSheet = false
    @StateObject var countryChosen = CountryChosen()
    @State var realmViewController = RealmViewController()
    @State private var goToMainView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorScheme()
                    .ignoresSafeArea()
                VStack {
                    Text("Country of Residency")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.title2)
                        .padding(.bottom, 100)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke()
                        .frame(width: 300, height: 40)
                        .foregroundStyle(.white)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showSheet = true
                        }
                        .overlay {
                            HStack {
                                Text(countryChosen.text.isEmpty ? "Enter Country Of Residency " : "\(countryChosen.text)")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                    .padding()
                            }
                        }
                        .padding(.bottom, 50)
                    
                    Button {
                        print(countryChosen.text)
                        realmViewController.setModelContext(modelContext)
                        realmViewController.writeToRealm(country: countryChosen.text)
                        goToMainView = true
                    } label: {
                        Text("Get Started")
                            .foregroundColor(.white)
                            .padding(.horizontal, 100)
                            .padding(.vertical, 15)
                            .background(countryChosen.text.isEmpty ? Color.green.opacity(0.4) : Color.green)
                            .clipShape(Capsule())
                    }
                    .disabled(countryChosen.text.isEmpty)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 80)
            }
            .fullScreenCover(isPresented: $showSheet) {
                CountryOfResidence(countryChosen: countryChosen)
            }
        }
    }
}

#Preview {
    CountryChosenView()
}

