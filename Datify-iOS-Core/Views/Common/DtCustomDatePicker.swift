//
//  DtCustomDatePicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.09.2023.
//

import SwiftUI

struct DtCustomDatePicker: View {
    @Binding var selectedDate: Date

    @State private var selectedMonthIndex = 0
    @State private var day = 1
    @State private var year = 1990

    private let months = ["January".localize(), "February".localize(),
                          "March".localize(), "April".localize(),
                          "May".localize(), "June".localize(),
                          "July".localize(), "August".localize(),
                          "September".localize(), "October".localize(),
                          "November".localize(), "December".localize()]

    private var maxMonthForCurrentYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (year == currentYear - 16) ? Calendar.current.component(.month, from: Date()) : 12
    }

    private var maxDayForSelectedMonth: Int {
            let calendar = Calendar.current
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())

            if year == currentYear - 16 && selectedMonthIndex == (currentMonth - 1) {
                return Calendar.current.component(.day, from: Date())
            }

            let components = DateComponents(year: year, month: selectedMonthIndex + 1)
            if let date = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .month, for: date) {
                return range.count
            }
            return 1
        }

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let currentYear = Calendar.current.component(.year, from: Date())
        if year < 1920 || year > currentYear {
            self.year = currentYear
        }
    }

    var body: some View {
        HStack {
            DtCustomPicker(selectedItem: $day,
                           items: 1...maxDayForSelectedMonth) { day in Text("\(day)")}
            DtCustomPicker(selectedItem: $selectedMonthIndex,
                           items: 0...maxMonthForCurrentYear-1) {index in Text(months[index])}
            DtCustomPicker(selectedItem: $year,
                           items: 1920...Calendar.current.component(.year, from: Date())-16) {year in Text("\(year.description)")}

        }
        .onChange(of: day) { _ in
            updateSelectedDate()
        }
        .onChange(of: selectedMonthIndex) { _ in
            if day > maxDayForSelectedMonth {
                day = maxDayForSelectedMonth
            }
            updateSelectedDate()
        }
        .onChange(of: year) { _ in
            if day > maxDayForSelectedMonth {
                day = maxDayForSelectedMonth
            }
            updateSelectedDate()
        }
        .padding(.horizontal)
    }

    private func updateSelectedDate() {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: selectedMonthIndex + 1, day: day)
        if let date = calendar.date(from: dateComponents) {
            selectedDate = date
        }
    }
}

struct DtCustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DtCustomDatePicker(selectedDate: .constant(Date()))
    }
}
