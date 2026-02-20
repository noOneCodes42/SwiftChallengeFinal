//
//  SwiftUIView.swift
//  SwiftChallengePt4
//
//  Created by Neel Arora on 2/20/26.
//

import SwiftUI

struct XcodeOnBoardingView<Content: View, Logo: View>: View{
    var limeGreen = Color(red: 0.1803921568627451, green: 0.7490196078431373, blue: 0.5686274509803921   )
    var paleGreen = Color(red: 0.5764705882352941, green: 0.9764705882352941, blue: 0.7254901960784313)
    var tint: Color = Color.green
    var foregroundColor: Color
    @ViewBuilder var logo: (_ isAnimating: Bool) -> Logo
    @ViewBuilder var content: (_ isAnimating: Bool) -> Content
    @State private var properties: Properties = .init()
    
    var body: some View {
        let layout = properties.convertToLogo ? AnyLayout(VStackLayout(spacing: 0)) : AnyLayout(ZStackLayout(alignment: .bottom))
        ZStack{
            Color.green
                .ignoresSafeArea(edges: .all)
            layout{
                ZStack{
                    Circle()
                        .fill(tint)
                        .scaleEffect(properties.animateMainCircle ? 2 : 0)
                        .ignoresSafeArea()
                    GridLines()
                    CirclesView()
                    CircleStrokesView()
                    DiagonalLines()
                    logo(properties.convertToLogo)
                        .opacity(properties.convertToLogo ? 1 : 0)
                        .blur(radius: properties.convertToLogo ? 0 : 50)
                        .compositingGroup()
                }

                .frame(width: properties.convertToLogo ? 200 : 370, height: properties.convertToLogo ? 200 : 450)
                .clipShape(.rect(cornerRadius: properties.convertToLogo ? 50 : 30))
                let isAnimating = properties.convertToLogo
                content(isAnimating)
                    .visualEffect { content, proxy in
                        content.offset(y: isAnimating ? 0 : proxy.size.height)
                        
                    }
                    .opacity(isAnimating ? 1 : 0)
                
            }
            .frame(width: 370, height: 450)
            .background(tint)
            
            .clipShape(.rect(cornerRadius: 30))
            .onAppear{
                guard !properties.animateMainCircle else { return }
                
                Task {
                    await delayAnimation(0.1, .easeInOut(duration: 0.5)) {
                        properties.animateMainCircle = true
                    }
                    
                    await delayAnimation(0.15, .bouncy(duration: 0.35, extraBounce: 0.2)) {
                        properties.circleScale = 1
                    }
                    
                    await delayAnimation(0.3, .bouncy(duration: 0.5)) {
                        properties.circleOffset = 50
                    }
                    
                    await delayAnimation(0.1, .bouncy(duration: 0.4)) {
                        properties.circleSize = 5
                    }
                    await delayAnimation(0.25, .linear(duration: 0.4)) {
                        properties.positionCircles = true
                    }
                    await delayAnimation(0.35, .linear(duration: 1)) {
                        properties.animationStrokes = true
                    }
                    await delayAnimation(0.3, .linear(duration: 0.6)) {
                        properties.animateGrideLines = true
                    }
                    await delayAnimation(0.15, .linear(duration: 0.5)) {
                        properties.animateDiagonalLines = true
                    }
                    await delayAnimation(0.5, .bouncy(duration: 0.5, extraBounce: 0)) {
                        properties.convertToLogo = true
                    }
                    
                }
            }
        }
    }
    @ViewBuilder
    func CirclesView() -> some View{
        ZStack{
            ForEach(1...4, id: \.self) { index in
                let rotation = (CGFloat(index) / 4.0) * 360
                let extraRotation: CGFloat = properties.positionCircles ? 20 : 0
                let extraOffset: CGFloat = index % 2 != 0 ? 40 : -20
                
                Circle()
                    .fill(foregroundColor)
                    .frame(width: properties.circleSize, height: properties.circleSize)
                    .animation(.easeInOut(duration: 0.05).delay(0.35)) {
                        
                        $0.scaleEffect(properties.positionCircles ? 0 : 1)
                    }
                    .offset(x: properties.positionCircles ? (120 + extraOffset) : properties.circleOffset)
                    .rotationEffect(.init(degrees: rotation + extraRotation))
                    .animation(.easeInOut(duration: 0.2).delay(0.2)) {
                        
                        $0.rotationEffect(.init(degrees: properties.positionCircles ? 12 : 0))
                    }
                
            }
        }
        .compositingGroup()
        .scaleEffect(properties.circleScale)
    }
    
    @ViewBuilder
    func CircleStrokesView() -> some View{
        ZStack{
            Circle()
                .trim(from: 0, to: properties.animationStrokes ? 1 : 0)
                .stroke(foregroundColor, lineWidth: 1)
                .frame(width: 70, height: 70)
                .scaleEffect(properties.convertToLogo ? 2.5 : 1)
            
            ForEach(1...4, id: \.self) { index in
                let rotation = (CGFloat(index) / 4.0) * 360
                let extraRotation: CGFloat = 20 + 12
                let extraOffset: CGFloat = index % 2 != 0 ? 120 : 0
                let isFaded = index == 3 || index == 4
                Circle()
                    .trim(from: 0, to: properties.animationStrokes ? 1 : 0)
                    .stroke(foregroundColor.opacity(isFaded ? 0.3 : 1), lineWidth: 1)
                    .frame(width: 200 + extraOffset, height: 200 + extraOffset)
                    .rotationEffect(.init(degrees: rotation + extraRotation))
            }
        }
        .compositingGroup()
        .scaleEffect(properties.convertToLogo ? 1.5 : 1)
        .opacity(properties.convertToLogo ? 0 : 1)
    }
    
    @ViewBuilder
    func GridLines() -> some View{
        ZStack{
            HStack{
                
                ForEach(1...5, id: \.self){ index in
                    Rectangle()
                        .fill(foregroundColor.tertiary)
                        .frame(width: 1, height: properties.animateGrideLines ? nil : 0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .scaleEffect(y: index == 2 || index == 4 ? -1 : 1)
                    
                }
            }
                VStack(spacing: 0){
                    ForEach(1...5, id: \.self){ index in
                        Rectangle()
                            .fill(foregroundColor.tertiary)
                            .frame(width: properties.animateGrideLines ? nil : 0, height: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .scaleEffect(x: index == 1 || index == 3 ? -1 : 1)
                        
                    }
                }
            }
        .compositingGroup()
        .opacity(properties.convertToLogo ? 0 : 1)
    }
    
    @ViewBuilder
    func DiagonalLines() -> some View{
        ZStack{
            Rectangle()
                .fill(foregroundColor.tertiary)
                .frame(width: 1, height: properties.animateDiagonalLines ? nil : 0)
                .padding(.vertical, -100)
                .frame(maxHeight: .infinity, alignment: .top)
                .rotationEffect(.init(degrees: -39))
            Rectangle()
                .fill(foregroundColor.tertiary)
                .frame(width: 1, height: properties.animateDiagonalLines ? nil : 0)
                .padding(.vertical, -100)
                .frame(maxHeight: .infinity, alignment: .top)
                .rotationEffect(.init(degrees: 39))
        }
        .compositingGroup()
        .opacity(properties.convertToLogo ? 0 : 1)
    }
    struct Properties{
        var animateMainCircle: Bool = false
        var circleSize: CGFloat = 50
        var circleOffset: CGFloat = 0
        var circleScale: CGFloat = 0
        var positionCircles: Bool = false
        var animationStrokes: Bool = false
        var animateGrideLines: Bool = false
        var animateDiagonalLines: Bool = false
        var convertToLogo: Bool = false
    }
    func delayAnimation(_ delay: Double, _ animation: Animation, perform action: @escaping () -> Void) async {
        try? await Task.sleep(for: .seconds(delay))
        withAnimation(animation){
            action()
        }
    }
}

#Preview {
    XcodeOnBoardingView(foregroundColor: .white) { isAnimating in
        
        Image("AppIconLaunchScreen")
            .resizable()
            .frame(width: 385, height: 385)

            .scaleEffect(isAnimating ? 0.5 : 1)
            .foregroundStyle(.white)
    } content: { isAnimating in
        VStack(spacing: 15){
            Text("Welcome To EcoHelp")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .padding(.top, 20)

        }
    }

}
    
