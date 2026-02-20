////
////  SignOutPage.swift
////  Swift International Challenge P1
////
////  Created by Neel Arora on 2/16/26.
////
//
//import SwiftUI
//
//struct SignOutPage: View {
//    @State var signOutController = SignOut()
//    
//    var body: some View {
//        ZStack {
//            ColorScheme()
//                .ignoresSafeArea()
//            
//            VStack(spacing: 50) {
//                
//                // Title
//                Text("Sign Out")
//                    .font(.system(size: 36, weight: .bold, design: .rounded))
//                    .foregroundStyle(.white)
//                    .padding(.top, 80)
//                
//                // Info / Icon
//                VStack(spacing: 20) {
//                    Image(systemName: "person.crop.circle.fill.badge.xmark")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 120, height: 120)
//                        .foregroundStyle(.white.opacity(0.8))
//                    
//                    Text("You are about to log out of your account and lose all the stored data")
//                        .foregroundStyle(.white.opacity(0.9))
//                        .font(.title3)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 40)
//                }
//                
//                Spacer()
//                
//                // Sign Out Button
//                Button {
//                    
//                    signOutController.signOut()
//                } label: {
//                    HStack {
//                        Text("Log Out")
//                            .font(.title2)
//                            .foregroundStyle(.white)
//                            .bold()
//                    }
//                    .foregroundStyle(.white)
//                    .frame(width: 280, height: 55)
//                    .background(
//                        LinearGradient(colors: [Color.green, Color.yellow], startPoint: .leading, endPoint: .trailing)
//                    )
//                    .cornerRadius(15)
//                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
//                }
//                
//                Spacer()
//            }
//        }
//    }
//}
