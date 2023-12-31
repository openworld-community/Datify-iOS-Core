//
//  EnterBirthdayView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.09.2023.
//

import SwiftUI

struct RegBirthdayView: View {
    unowned let router: Router<AppRoute>
    @State private var selectedDate: Date = Calendar
        .current
        .date(byAdding: .year, value: -16, to: Date()) ?? Date()
    @State private var showAlert: Bool = false

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
            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    // TODO: - Proceed button action
                    // По хорошему надо проверить подтянув текущую дату с бэка, чтобы пользователь не мог просто изменить дату на телефоне и обойти ограничение по возрасту
                    router.push(.registrationOccupation)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DtLogoView()
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden()
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("You must be at least 16 years old to register"))
        })
    }
}

struct RegBirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegBirthdayView(router: Router())
        }
    }
}
