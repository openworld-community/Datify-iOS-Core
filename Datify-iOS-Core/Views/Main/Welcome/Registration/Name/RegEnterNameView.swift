//
//  EnterNameView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 13.09.2023.
//

import SwiftUI

struct RegEnterNameView: View {
    unowned let router: Router<AppRoute>
    @State private var name: String = .init()

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            VStack(spacing: 8) {
                Text("What is your name?")
                    .dtTypo(.h3Regular, color: .textPrimary)
                Text("This name will be shown to other users")
                    .dtTypo(.p3Regular, color: .textSecondary)
            }
            DtCustomTF(
                style: .text("Enter name".localize(), .center),
                input: $name) {
                    if nameIsValid() {
                        continueButtonAction()
                    }
                }
            Spacer()
            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    continueButtonAction()
                }
                .disabled(!nameIsValid())
            }
        }
        .navigationBarBackButtonHidden()
        .hideKeyboardTapOutside()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .onChange(of: name, perform: { newValue in
            name = newValue.trimLeadingSpaces()
        })
        .padding(.horizontal)
        .padding(.bottom)

    }

    private func nameIsValid () -> Bool {
        name.count > 0 && name.count < 30
    }

    private func continueButtonAction() {
        if name == name.trimWhitespaceCapit() {
            // TODO: - Proceed button action
            router.push(.registrationBirthday)
        } else {
            // Преобразует введеное имя убирая повторяющиеся пробелы и пробелы в конце, все слова пишет с большой буквы
            name = name.trimWhitespaceCapit()
        }
    }
}

struct RegEnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegEnterNameView(router: Router())
        }
    }
}
