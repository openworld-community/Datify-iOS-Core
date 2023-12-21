//
//  DtDateFormatter.swift
//  Datify-iOS-Core
//
//  Created by Илья on 28.11.2023.
//

import Foundation

enum DtDateFormatter {
    static func basicTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func advancedDate(date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        if let aWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()),
           date >= aWeekAgo {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE" // 'EE' для сокращенного названия дня недели
            formatter.locale = Locale(identifier: "ru_RU") // Установка локали для русских сокращений
            return formatter.string(from: date)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd:MM"
        return formatter.string(from: date)
    }
}
