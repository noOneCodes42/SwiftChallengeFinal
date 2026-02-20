//
//  RectangleView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import SwiftUI

struct RectangleView: View{
    let content: String
    let sfSymbol: String
    let worth: Int
    var completed: Bool = false
    var body: some View{
        RoundedRectangle(cornerRadius: 12)
            .overlay{
                HStack{
                    Image(systemName: "\(sfSymbol)")
                        .foregroundStyle(Color.black)
                        .padding()
                    ZStack{
                        Text("\(content)")
                            .foregroundStyle(Color.black)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        HStack{
                            Image("goat")
                                .resizable()
                                .frame(width: 17, height: 17)
                                .padding(.bottom, 60)
                                .padding(.leading, 90)
                            Text("\(worth)")
                                .foregroundStyle(Color.black)
                                .font(.footnote)
                                .padding(.bottom, 60)
                        }
                    }
                    
                    
                }
            }
        
            .frame(width: 250, height: 100)
            .foregroundStyle(Color.white)

        
        
        
    }
}
