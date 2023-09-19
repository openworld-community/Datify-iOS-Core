//
//  EnterNameView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 13.09.2023.
//

import SwiftUI

struct RegEnterNameView: View {
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
            DtCustomTF(style: .text("Enter name".localize(), .center), input: $name)
            Spacer()
            HStack(spacing: 10) {
                DtBackButton {
                    // TODO: - Back button action
                }
                DtButton(title: "Proceed".localize(), style: .main) {
                    if nameIsValid() && name == name.trimWhitespaceCapit() {
                        // TODO: - Proceed button action
                    } else {
                        // Преобразует введеное имя убирая повторяющиеся пробелы и пробелы в конце, все слова пишет с большой буквы
                        name = name.trimWhitespaceCapit()
                    }
                }
                .disabled(!nameIsValid())
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .onChange(of: name, perform: { newValue in
            name = newValue.trimLeadingSpaces()
        })
        .padding(.horizontal)
        .padding(.bottom, 8)

    }

    private func nameIsValid () -> Bool {
        name.count > 0 && name.count < 30
    }
}

struct RegEnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegEnterNameView()
        }
    }
}
