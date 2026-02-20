//
//  CalendarController.swift
//  Swift International Challenge P1
//
//  Created by Neel Arora on 2/17/26.
//

import Foundation
import SwiftData
import SwiftUI
// / Originally I made this project as an XCode app thinking that, that was supported for submission however it turns out it needed an .swiftpm. Which is why I had to convert from RealmSwift to SwiftData which is why some of the controllers name are realm  and not swiftdata. Along with why my file creations are off because I just copied my xcode app code here so the creation comments on the top are still related to the original xcode project.
@Observable
class CalendarController {
    var today: CalendarRealmModel?
    var weekStartDate: Date = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func fetchToday() {
        guard let modelContext = modelContext else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<CalendarRealmModel> { log in
            log.date >= startOfDay && log.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<CalendarRealmModel>(predicate: predicate)
        
        do {
            let logs = try modelContext.fetch(descriptor)
            today = logs.first
        } catch {
            print("Failed to fetch today: \(error)")
        }
    }
    
    func getAllDays(for date: Date) -> CalendarRealmModel? {
        guard let modelContext = modelContext else { return nil }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<CalendarRealmModel> { log in
            log.date >= startOfDay && log.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<CalendarRealmModel>(predicate: predicate)
        
        do {
            let logs = try modelContext.fetch(descriptor)
            return logs.first
        } catch {
            print("Failed to fetch logs for date: \(error)")
            return nil
        }
    }
    
    func addData(name modelName: String, saved: Double, on date: Date) {
        guard let modelContext = modelContext else { return }
        
        // Set the date to the end of the day (23:59:59)
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        guard let endOfDay = Calendar.current.date(from: components) else {
            print("Failed to compute end of day")
            return
        }
        
        // Compute start and end of day for checking
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDayCheck = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<CalendarRealmModel> { log in
            log.date >= startOfDay && log.date < endOfDayCheck
        }
        
        let descriptor = FetchDescriptor<CalendarRealmModel>(predicate: predicate)
        
        do {
            let existingLogs = try modelContext.fetch(descriptor)
            
            if let existingLog = existingLogs.first {
                // Update existing log
                existingLog.carbonSaved = saved
                existingLog.modelName = modelName
                existingLog.date = endOfDay
            } else {
                // Create new log
                let newLog = CalendarRealmModel(modelName: modelName, carbonSaved: saved, date: endOfDay)
                modelContext.insert(newLog)
            }
            
            try modelContext.save()
        } catch {
            print("Unable to update/write log:", error)
        }
    }
}
