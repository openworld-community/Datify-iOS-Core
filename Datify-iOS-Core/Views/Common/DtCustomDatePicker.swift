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
        return Months.allCases.filter { $0.rawValue <= maxMonth }
    }
}

struct DtCustomDatePicker: View {
    @Binding var selectedDate: Date
    private var minimumAge: Int

    @State private var selectedMonth: Months
    @State private var selectedDay: Int
    @State private var selectedYear: Int

    private var maxMonthForCurrentYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (selectedYear == currentYear - minimumAge) ? Calendar.current.component(.month, from: Date()) : 12
    }

    private var maxDayForSelectedMonth: Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())

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

    init(selectedDate: Binding<Date>, minimumAge: Int = 16) {
        self._selectedDate = selectedDate
        self.minimumAge = minimumAge
        let minimumDate = Calendar.current.date(byAdding: .year, value: -minimumAge, to: Date()) ?? Date()
        let calendar = Calendar.current
        self._selectedDay = State(
            wrappedValue:
                calendar.component(.day, from: minimumDate))
        self._selectedYear = State(
            wrappedValue:
                calendar.component(.year, from: minimumDate))
        self._selectedMonth = State(
            wrappedValue:
                Months(rawValue: calendar.component(.month, from: minimumDate)) ?? Months.january)
    }

    var body: some View {
        HStack {
            DtCustomPicker(
                selectedItem: $selectedDay,
                items: Array(1...maxDayForSelectedMonth)
            ) { day in
                Text("\(day)")
            }
            DtCustomPicker(
                selectedItem: $selectedMonth,
                items: selectedMonth.arrayOfIndices(maxMonth: maxMonthForCurrentYear)
            ) { month in
                Text(month.description)
            }
            DtCustomPicker(
                selectedItem: $selectedYear,
                items: Array(1920...Calendar.current.component(.year, from: Date()) - minimumAge)
            ) { year in
                Text(year.description)
            }
        }

        .onChange(of: selectedDay) { _ in
            updateSelectedDate()
        }
        .onChange(of: selectedMonth) { _ in
            checkDate()
        }
        .onChange(of: selectedYear) { _ in
            checkDate()
            if selectedMonth.rawValue > maxMonthForCurrentYear {
                selectedMonth = Months(rawValue: maxMonthForCurrentYear) ?? Months.january
            }
        }
        .padding(.horizontal)
    }

    private func checkDate() {
        if selectedDay > maxDayForSelectedMonth {
            selectedDay = maxDayForSelectedMonth
        }
        updateSelectedDate()
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
