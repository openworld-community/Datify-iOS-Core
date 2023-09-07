//
//  RegEmailView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 07.09.2023.
//

import SwiftUI

struct RegEmailView: View {
    private unowned let router: Router<AppRoute>
    @StateObject private var viewModel: RegEmailViewModel

    init(router: Router<AppRoute>,
         viewModel: RegEmailViewModel = RegEmailViewModel(router: nil)
    ) {
        self.router = router
        _viewModel = StateObject(wrappedValue: RegEmailViewModel(router: router))
    }

    var body: some View {
        VStack {
            DtLogoView()

            Spacer()

            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Enter your email")
                        .dtTypo(.h3Medium, color: .textPrimary)

                    Text("This is required to create an account")
                        .dtTypo(.p2Regular, color: .textSecondary)
                }

                VStack(spacing: 16) {
                    DtTextFieldView(
                        text: $viewModel.email,
                        placeholder: String(localized: "Enter email"),
                        image: nil,
                        submitLabel: .continue,
                        action: {})
                    .onSubmit {
                        if !viewModel.isButtonDisabled {
                            viewModel.validateEmail()
                        }
                    }

                    Button {
                        // TODO: viewModel.router.push...
                    } label: {
                        Text("Registration by phone number")
                            .dtTypo(.p3Medium, color: .textPrimaryLink)
                    }
                }
            }

            Spacer()

            DtButton(
                title: String(localized: "Continue"),
                style: .main
            ) {
                viewModel.validateEmail()
            }
            .disabled(viewModel.isButtonDisabled)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .alert(
            String(localized: "Wrong format of email address. Please try again!"),
            isPresented: $viewModel.isWrongFormat
        ) {

        }
    }
}

struct RegEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegEmailView(router: Router())
    }
}
