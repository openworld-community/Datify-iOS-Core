//
//  EnterNameView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 13.09.2023.
//

import SwiftUI

struct EnterNameView: View {
    @State private var name: String = .init()
    @ObservedObject var viewModel: RegEmailViewModel
    var body: some View {
        VStack(spacing: 40) {
            DtLogoView()
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
                    // TODO: - Proceed button action
                }
                .disabled(!nameIsValid())
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func nameIsValid () -> Bool {
        name.count > 1 && name.count < 16
    }
}

struct EnterNameView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNameView(viewModel: RegEmailViewModel(router: Router()))
    }
}
