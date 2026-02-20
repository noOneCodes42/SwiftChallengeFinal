//
//  MainTaskView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 8/11/25.
//


import SwiftUI

struct MainTaskView: View {
    @State var selectedTask: RectangleViewUseable?
    @State var firstRow = [
        RectangleViewUseable(content: "Pick up 5 pieces of trash", sfSymbol: "trash.circle.fill", worth: 10),
        RectangleViewUseable(content: "Walk instead of getting a ride", sfSymbol: "figure.walk", worth: 15),
        RectangleViewUseable(content: "Take public transportation", sfSymbol: "bus.fill", worth: 20),
        RectangleViewUseable(content: "Turn off computer instead of sleep mode", sfSymbol: "desktopcomputer", worth: 15),
        RectangleViewUseable(content: "Unplug chargers when not in use", sfSymbol: "cable.connector", worth: 5),
        RectangleViewUseable(content: "Use energy-efficient light bulbs", sfSymbol: "lightbulb.fill", worth: 12),
        RectangleViewUseable(content: "Lower brightness on monitor", sfSymbol: "sun.min.fill", worth: 5),
        RectangleViewUseable(content: "Turn off lights when leaving a room", sfSymbol: "lightbulb.slash.fill", worth: 8),
        RectangleViewUseable(content: "Air dry clothes instead of using dryer", sfSymbol: "wind", worth: 15),
        RectangleViewUseable(content: "Wash clothes in cold water", sfSymbol: "drop.fill", worth: 10)
    ]

    @State var secondRow = [
        RectangleViewUseable(content: "Reuse school supplies before buying new ones", sfSymbol: "pencil.and.outline", worth: 8),
        RectangleViewUseable(content: "Bring a reusable water bottle", sfSymbol: "drop.circle.fill", worth: 5),
        RectangleViewUseable(content: "Use a reusable lunch container", sfSymbol: "takeoutbag.and.cup.and.straw.fill", worth: 8),
        RectangleViewUseable(content: "Eat one plant-based meal today", sfSymbol: "leaf.fill", worth: 20),
        RectangleViewUseable(content: "Avoid single-use plastics today", sfSymbol: "nosign", worth: 12),
        RectangleViewUseable(content: "Compost food scraps", sfSymbol: "leaf.circle.fill", worth: 15),
        RectangleViewUseable(content: "Pack lunch from home", sfSymbol: "lunchbox.fill", worth: 10),
        RectangleViewUseable(content: "Buy locally grown produce", sfSymbol: "basket.fill", worth: 10),
        RectangleViewUseable(content: "Avoid excess packaging when shopping", sfSymbol: "shippingbox.fill", worth: 10),
        RectangleViewUseable(content: "Refuse plastic straws", sfSymbol: "xmark.circle.fill", worth: 5)
    ]

    @State var thirdRow = [
        RectangleViewUseable(content: "Choose vegetarian option when possible", sfSymbol: "carrot.fill", worth: 15),
        RectangleViewUseable(content: "Reduce food waste by saving leftovers", sfSymbol: "fork.knife", worth: 10),
        RectangleViewUseable(content: "Recycle paper and plastic properly", sfSymbol: "arrow.3.trianglepath", worth: 10),
        RectangleViewUseable(content: "Use a fan instead of AC when possible", sfSymbol: "fan.fill", worth: 10),
        RectangleViewUseable(content: "Drink tap water instead of bottled water", sfSymbol: "drop.circle", worth: 5),
        RectangleViewUseable(content: "Bring a reusable coffee cup", sfSymbol: "cup.and.saucer.fill", worth: 8),
        RectangleViewUseable(content: "Avoid buying fast fashion items", sfSymbol: "tshirt.circle.fill", worth: 20),
        RectangleViewUseable(content: "Plant a tree or join tree planting event", sfSymbol: "tree.fill", worth: 30),
        RectangleViewUseable(content: "Educate someone about sustainability", sfSymbol: "person.2.fill", worth: 10),
        RectangleViewUseable(content: "Use digital notes instead of paper", sfSymbol: "ipad.and.pencil", worth: 8)
    ]

    @State var fourthRow = [
        RectangleViewUseable(content: "Open windows for natural ventilation", sfSymbol: "window.horizontal", worth: 10),
        RectangleViewUseable(content: "Close the fridge quickly after opening", sfSymbol: "refrigerator.fill", worth: 5),
        RectangleViewUseable(content: "Donate old clothes instead of throwing away", sfSymbol: "tshirt.fill", worth: 12),
        RectangleViewUseable(content: "Refill notebooks instead of buying new ones", sfSymbol: "book.fill", worth: 8),
        RectangleViewUseable(content: "Repair items instead of replacing them", sfSymbol: "wrench.fill", worth: 15),
        RectangleViewUseable(content: "Buy second-hand clothing or items", sfSymbol: "tag.fill", worth: 15),
        RectangleViewUseable(content: "Recycle old electronics responsibly", sfSymbol: "desktopcomputer.trianglebadge.exclamationmark", worth: 15),
        RectangleViewUseable(content: "Reuse packaging materials", sfSymbol: "cube.fill", worth: 8),
        RectangleViewUseable(content: "Switch off power strips at night", sfSymbol: "powerplug.fill", worth: 10),
        RectangleViewUseable(content: "Use natural light during the day", sfSymbol: "sun.max.fill", worth: 8)
    ]

    @State var fifthRow = [
        RectangleViewUseable(content: "Take a 2-minute shower", sfSymbol: "shower.handheld.fill", worth: 15),
        RectangleViewUseable(content: "Turn off tap while brushing teeth", sfSymbol: "drop.fill", worth: 5),
        RectangleViewUseable(content: "Fix small water leaks at home", sfSymbol: "wrench.and.screwdriver.fill", worth: 15),
        RectangleViewUseable(content: "Use cold water for laundry cycles", sfSymbol: "snowflake", worth: 10),
        RectangleViewUseable(content: "Work or study from home to reduce travel", sfSymbol: "house.fill", worth: 20),
        RectangleViewUseable(content: "Carpool with friends or family", sfSymbol: "car.2.fill", worth: 20),
        RectangleViewUseable(content: "Use rechargeable batteries", sfSymbol: "battery.100.bolt", worth: 12),
        RectangleViewUseable(content: "Support eco-friendly brands", sfSymbol: "checkmark.seal.fill", worth: 10),
        RectangleViewUseable(content: "Avoid food delivery for one day", sfSymbol: "bicycle", worth: 15),
        RectangleViewUseable(content: "Turn off notifications to save battery", sfSymbol: "bell.slash.fill", worth: 5)
    ]

    @State var currentListOfTasks: [RectangleViewUseable] = []
    @State var currentAmountOfMoney: Int = 0
    
    @Environment(CoinViewController.self) private var coinController
    @Environment(CarbonFootPrintSavedController.self) private var carbonSavedController
    @Environment(CarbonEmissionDailyController.self) private var carbonSavedDaily
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top){
            ColorScheme()
                .ignoresSafeArea()
            
            // Coin display
            HStack{
                Spacer()
                Image("goat")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("\(coinController.currentAmount)")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            .padding()
            
            Text("Tasks")
                .padding()
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.custom("Arial Rounded MT Bold", size: 40))
            
            VStack(spacing: 0){
                ScrollView(.horizontal){
                    HStack{
                        ForEach(firstRow) { task in
                            if !task.completed {
                                RectangleView(content: task.content, sfSymbol: task.sfSymbol, worth: task.worth)
                                    .onTapGesture{
                                        selectedTask = task
                                        currentListOfTasks = firstRow
                                    }
                            }
                        }
                    }
                }
                .padding()
                .padding(.top, 100)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(secondRow) { task in
                            if !task.completed {
                                RectangleView(content: task.content, sfSymbol: task.sfSymbol, worth: task.worth)
                                    .onTapGesture{
                                        selectedTask = task
                                        currentListOfTasks = secondRow
                                    }
                            }
                        }
                    }
                }
                .padding()
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(thirdRow) { task in
                            if !task.completed {
                                RectangleView(content: task.content, sfSymbol: task.sfSymbol, worth: task.worth)
                                    .onTapGesture{
                                        selectedTask = task
                                        currentListOfTasks = thirdRow
                                    }
                            }
                        }
                    }
                }
                .padding()
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(fourthRow) { task in
                            if !task.completed {
                                RectangleView(content: task.content, sfSymbol: task.sfSymbol, worth: task.worth)
                                    .onTapGesture{
                                        selectedTask = task
                                        currentListOfTasks = fourthRow
                                    }
                            }
                        }
                    }
                }
                .padding()
                ScrollView(.horizontal){
                    HStack{
                        ForEach(fifthRow) { task in
                            if !task.completed {
                                RectangleView(content: task.content, sfSymbol: task.sfSymbol, worth: task.worth)
                                    .onTapGesture{
                                        selectedTask = task
                                        currentListOfTasks = fifthRow
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        // Use your existing TaskSheetView
        .sheet(item: $selectedTask){ task in
            TaskSheetView(
                task: task,
                listOfTasks: $currentListOfTasks,
                currentAmountOfMoney: $currentAmountOfMoney,
                selectedTask: $selectedTask,
                coinController: coinController, carbonSavedController: carbonSavedController, carbonSavedDaily: carbonSavedDaily
            )
        }
    }
}
