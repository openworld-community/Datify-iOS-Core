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
}
