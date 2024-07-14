//
//  dateExtensions.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/8/24.
//

import Foundation
import SwiftUI

extension Date{
    
    func format(_ format : String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var isToday : Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isSameHour : Bool {
        return Calendar.current.compare(self, to : .init(), toGranularity: .hour) == .orderedSame
    }
    
    var isPastHour : Bool {
        return Calendar.current.compare(self, to : .init(), toGranularity : .hour) == .orderedAscending
    }
    
    func isSameDate(_ date1 : Date , _ date2 : Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    struct Weekday: Identifiable{
        var id : UUID = .init()
        var date : Date
    }
    
    func fetchWeek(_ date : Date = .init()) -> [Weekday] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        var week : [Weekday] = []
        let weekForDate = calendar.dateInterval(of: .weekOfYear, for: startDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekday = calendar.date(byAdding: .day, value: index, to: startOfWeek){
                week.append(.init(date: weekday))
            }
            
        }
        print(week)
        return week
    }
    
    func fetchNextWeek() -> [Weekday] {
        let calendar = Calendar.current
        let startofLastDate = calendar.startOfDay(for: self)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startofLastDate) else {
            return []
        }
        return fetchWeek(nextDate)
    }
    
    func fetchPreviousWeek() -> [Weekday] {
        let calendar = Calendar.current
        let startofFirstDate = calendar.startOfDay(for: self)
        
        guard let prevDate = calendar.date(byAdding: .day, value: -1, to: startofFirstDate) else {
            return []
        }
        return fetchWeek(prevDate)
    }
}

