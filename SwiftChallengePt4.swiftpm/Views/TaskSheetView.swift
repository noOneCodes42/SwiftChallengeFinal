//
//  TaskSheetView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/16/26.
//

import SwiftUI

struct TaskSheetView: View {
    let task: RectangleViewUseable
    @Binding var listOfTasks: [RectangleViewUseable]
    @Binding var currentAmountOfMoney: Int
    @Binding var selectedTask: RectangleViewUseable?
    
    let coinController: CoinViewController
    let carbonSavedController: CarbonFootPrintSavedController
    let carbonSavedDaily: CarbonEmissionDailyController
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        selectedTask = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(25)

            VStack {
                Image(systemName: task.sfSymbol)
                    .foregroundStyle(.black)
                    .font(.title)
                    .padding()

                Text(task.content)
                    .multilineTextAlignment(.center)

                Button {
                    completeTask()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 200, height: 40)
                        .overlay(
                            Text("Mark as complete")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        )
                }
                .padding(.top, 30)
            }
            .presentationDetents([.medium])

            HStack {
                Image("goat")
                    .resizable()
                    .frame(width: 17, height: 17)

                Text("\(task.worth)")
            }
            .padding(.bottom, 300)
            .padding(.leading, 300)
        }
    }

    private func completeTask() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Add coins
        coinController.addCoinToRealm(amount: task.worth)
        carbonSavedController.addAmount(coinAmount: Double(task.worth))
        carbonSavedDaily.addAmount(coinAmount: Double(task.worth))
        print(carbonSavedController.carbonFootPrintSaved)
        // Mark task as completed
        if let index = listOfTasks.firstIndex(where: { $0.id == task.id }) {
            listOfTasks[index].completed = true
        }
        
        selectedTask = nil
    }
}

