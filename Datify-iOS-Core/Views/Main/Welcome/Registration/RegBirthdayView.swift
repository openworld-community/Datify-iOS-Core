//
//  EnterBirthdayView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.09.2023.
//

import SwiftUI

struct RegBirthdayView: View {
    @State private var selectedDate: Date
    @State private var showAlert: Bool = false

    init() {
        var dateComponents = DateComponents()
        dateComponents.year = 1990
        dateComponents.month = 1
        dateComponents.day = 1
        _selectedDate = State(wrappedValue: Calendar.current.date(from: dateComponents) ?? Date())
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            VStack(spacing: 8) {
                Text("When is your birthday?")
                    .dtTypo(.h3Regular, color: .textPrimary)
                Text("Other users will only see your age")
                    .dtTypo(.p3Regular, color: .textSecondary)
            }
            DtCustomDatePicker(selectedDate: $selectedDate)
            Spacer()
            HStack(spacing: 10) {
                DtBackButton {
                    // TODO: - Back button action
                }
                DtButton(title: "Proceed".localize(), style: .main) {
                    // TODO: - Proceed button action
                    // По хорошему надо проверить подтянув текущую дату с бэка, чтобы пользователь не мог просто изменить дату на телефоне и обойти ограничение по возрасту
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DtLogoView()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("You must be at least 16 years old to register"))
        })
    }
}

struct RegBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegBirthdayView()
        }
    }
}
