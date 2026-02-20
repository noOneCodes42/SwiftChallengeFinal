//
//  CalendarView.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//
import SwiftUI
import SwiftData
import RealityKit

// MARK: - Daily Entry Model
struct DayData {
    var modelName: String
    var carbonSaved: Double
}

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    private let calendar = Calendar.current
    @State private var selectedDate = Date()
    let numberOfdays = 7
    @State private var calendarController = CalendarController()
    
    // Unique model ID for RealityView refresh
    private var modelId: String {
        if let entry = dayData[calendar.startOfDay(for: selectedDate)] {
            return "\(entry.modelName)_\(selectedDate.timeIntervalSince1970)"
        }
        return "none"
    }
    
    private var dayData: [Date: DayData] {
        var dict: [Date: DayData] = [:]
        
        for offset in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: offset, to: calendarController.weekStartDate),
               let log = calendarController.getAllDays(for: date) {
                dict[Calendar.current.startOfDay(for: date)] = DayData(
                    modelName: log.modelName,
                    carbonSaved: log.carbonSaved
                )
            }
        }
        return dict
    }
    
    var body: some View {
        ZStack {
            ColorScheme()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Date Title
                Text(selectedDate.formatted(date: .complete, time: .omitted))
                    .font(.headline.bold())
                    .padding(.top, 20)
                
                // Week Calendar
                WeekCalendarView(
                    selectedDate: $selectedDate,
                    dayData: dayData
                )
                
                // Note below calendar
                if let entry = dayData[calendar.startOfDay(for: selectedDate)] {
                    Text("Carbon saved: \(entry.carbonSaved, specifier: "%.2f") tons")
                        .font(.body.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.green.opacity(0.2))
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            
            // MARK: - Model Overlay (FIXED)
            if let entry = dayData[calendar.startOfDay(for: selectedDate)] {
                RealityView { content in
                    let anchor = AnchorEntity()
                    content.add(anchor)
                    
                    // Load USDZ model from Bundle
                    if let url = Bundle.main.url(forResource: entry.modelName, withExtension: "usdz", subdirectory: "3D Models"),
                       let model = try? await ModelEntity(contentsOf: url) {
                        print("✅ Loaded calendar model: \(entry.modelName)")
                        // Unique name + fresh transform
                        model.name = modelId
                        model.scale = [0.6, 0.6, 0.6]        // Smaller
                        model.position = [0, 0, -1.2]           // Further back
                        
                        // COMPLETE RESET: Fresh state every time
                        model.transform = Transform(
                            scale: SIMD3(0.6, 0.6, 0.6),
                            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)),
                            translation: SIMD3(0, 0, -1.2)
                        )
                        
                        anchor.addChild(model)
                        Task {
                            await spinForEver(model: model)
                        }
                    } else {
                        print("Failed to load calendar model: \(entry.modelName)")
                    }
                }
                .id(modelId)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
        }
        .onAppear {
            calendarController.setModelContext(modelContext)
            calendarController.fetchToday()
        }
    }
    
    // MARK: - Infinite Rotation
    func spinForEver(model: ModelEntity) async {
        while true {
            let q = simd_quatf(angle: -0.01, axis: SIMD3<Float>(0, 1, 0))
            model.transform.rotation = q * model.transform.rotation
            try? await Task.sleep(nanoseconds: 16_000_000)
        }
    }
}

// MARK: - Week Calendar View (FIXED COLORS)
struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    var dayData: [Date: DayData]
    
    private let calendar = Calendar.current
    private let daysInWeek = 7
    @State private var weekStartDate: Date = Date()
    @Environment(\.colorScheme) private var colorScheme
    
    // Green-themed colors
    private var themeBackgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.13, green: 0.2, blue: 0.13, opacity: 0.95)
            : Color(red: 0.78, green: 0.92, blue: 0.78, opacity: 0.98)
    }
    
    private var themeAccentColor: Color {
        colorScheme == .dark
            ? Color.green.opacity(0.85)
            : Color.green.opacity(0.7)
    }
    
    init(selectedDate: Binding<Date>, dayData: [Date: DayData]) {
        self._selectedDate = selectedDate
        self.dayData = dayData
        
        let start = Calendar.current
            .dateInterval(of: .weekOfYear, for: selectedDate.wrappedValue)?
            .start ?? selectedDate.wrappedValue
        
        _weekStartDate = State(initialValue: start)
    }
    
    private var weekDates: [Date] {
        (0..<daysInWeek).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekStartDate)
        }
    }
    
    private var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let firstIndex = calendar.firstWeekday - 1
        return Array(symbols[firstIndex..<symbols.count]) + Array(symbols[0..<firstIndex])
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Weekday labels
            HStack(spacing: 0) {
                ForEach(0..<daysInWeek, id: \.self) { i in
                    Text(weekdaySymbols[i])
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary.opacity(0.7))
                }
            }
            
            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                    let isToday = calendar.isDateInToday(date)
                    
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.body.bold())
                            .frame(width: 38, height: 38)
                            .background(
                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(themeAccentColor)
                                            .overlay(
                                                Circle()
                                                    .stroke(themeAccentColor, lineWidth: 2)
                                            )
                                            .shadow(color: themeAccentColor.opacity(0.4), radius: 6)
                                    } else if isToday {
                                        Circle()
                                            .fill(Color.clear)
                                            .overlay(
                                                Circle()
                                                    .stroke(themeAccentColor.opacity(0.6), lineWidth: 1.5)
                                            )
                                    } else {
                                        Circle()
                                            .fill(Color.gray.opacity(0.1))
                                    }
                                }
                            )
                            .foregroundColor(isSelected ? .white : (isToday ? themeAccentColor : .primary))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { selectedDate = date }
                }
            }
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(themeBackgroundColor.opacity(0.96))
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        if value.translation.width < -50 {
                            withAnimation(.easeInOut) { changeWeek(by: 1) }
                        } else if value.translation.width > 50 {
                            withAnimation(.easeInOut) { changeWeek(by: -1) }
                        }
                    }
            )
            
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            if value.translation.width < -30 {
                                withAnimation(.easeInOut) { changeDay(by: 1) }
                            } else if value.translation.width > 30 {
                                withAnimation(.easeInOut) { changeDay(by: -1) }
                            }
                        }
                )
        }
        .padding(.horizontal)
        .onChange(of: selectedDate) { newDate in
            if let newWeekStart = calendar.dateInterval(of: .weekOfYear, for: newDate)?.start {
                withAnimation(.easeInOut) { weekStartDate = newWeekStart }
            }
        }
    }
    
    private func changeWeek(by offset: Int) {
        if let newStart = calendar.date(byAdding: .weekOfYear, value: offset, to: weekStartDate) {
            weekStartDate = newStart
            selectedDate = newStart
        }
    }
    
    private func changeDay(by offset: Int) {
        if let newDate = calendar.date(byAdding: .day, value: offset, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

#Preview {
    CalendarView()
}
