import SwiftUI

struct TotalCoinsMadeView: View {
    @Environment(CarbonFootPrintSavedController.self) private var carbonFootPrint
    
    var body: some View {
        ZStack {
            ColorScheme()
            
            VStack(spacing: 30) {
                
                Text("Total Coins Earned")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
                VStack(spacing: 16) {
                    
                    HStack(spacing: 12) {
                        Image("goat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        Text("\(String(format: "%.0f", carbonFootPrint.carbonFootPrintSaved))")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                    Text("Coins")
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
