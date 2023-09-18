//
//  DtCustomDatePicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.09.2023.
//

import SwiftUI

enum Months: Int, CaseIterable {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december

    var description: String {
        switch self {
        case .january:
            return "January".localize()
        case .february:
            return "February".localize()
        case .march:
            return "March".localize()
        case .april:
            return "April".localize()
        case .may:
            return "May".localize()
        case .june:
            return "June".localize()
        case .july:
            return "July".localize()
        case .august:
            return "August".localize()
        case .september:
            return "September".localize()
        case .october:
            return "October".localize()
        case .november:
            return "November".localize()
        case .december:
            return "December".localize()
        }
    }

    func arrayOfIndices(maxMonth: Int) -> [Months] {
        guard maxMonth <= 12 else {return []}
        var newArray: [Months] = .init()
        for index in 1...maxMonth {
            newArray.append(Months(rawValue: index)!)
        }
        return newArray
    }
}

struct DtCustomDatePicker: View {
    @Binding var selectedDate: Date
    private var minimumAge: Int

    @State private var selectedMonth = Months.january
    @State private var selectedDay = 1
    @State private var selectedYear = 1990

    private let months = ["January".localize(), "February".localize(),
                          "March".localize(), "April".localize(),
                          "May".localize(), "June".localize(),
                          "July".localize(), "August".localize(),
                          "September".localize(), "October".localize(),
                          "November".localize(), "December".localize()]

    private var maxMonthForCurrentYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (selectedYear == currentYear - minimumAge) ? Calendar.current.component(.month, from: Date()) : 12
    }

    private var maxDayForSelectedMonth: Int {
            let calendar = Calendar.current
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())

        if selectedYear == currentYear - minimumAge && selectedMonth.rawValue == currentMonth {
                return Calendar.current.component(.day, from: Date())
            }

        let components = DateComponents(year: selectedYear, month: selectedMonth.rawValue)
            if let date = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .month, for: date) {
                return range.count
            }
            return 1
        }

    init(selectedDate: Binding<Date>, minAge: Int = 16) {
        self._selectedDate = selectedDate
        self.minimumAge = minAge
    }

    var body: some View {
        HStack {
            DtCustomPicker(selectedItem: $selectedDay, items: Array(1...maxDayForSelectedMonth)) { day in
                Text("\(day)")
            }
            DtCustomPicker(selectedItem: $selectedMonth, items: selectedMonth.arrayOfIndices(maxMonth: maxMonthForCurrentYear)) { month in
                Text(month.description)
            }
            DtCustomPicker(selectedItem: $selectedYear, items: Array(1920...Calendar.current.component(.year, from: Date())-16)) { year in
                Text("\(year.description)")
            }
        }

        .onChange(of: selectedDay) { _ in
            updateSelectedDate()
        }
        .onChange(of: selectedMonth) { _ in
            if selectedDay > maxDayForSelectedMonth {
                selectedDay = maxDayForSelectedMonth
            }
            updateSelectedDate()
        }
        .onChange(of: selectedYear) { _ in
            if selectedDay > maxDayForSelectedMonth {
                selectedDay = maxDayForSelectedMonth
            }
            updateSelectedDate()
        }
        .padding(.horizontal)
    }

    private func updateSelectedDate() {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth.rawValue, day: selectedDay)
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
