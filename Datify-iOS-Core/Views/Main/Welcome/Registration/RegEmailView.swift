//
//  RegEmailView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 07.09.2023.
//

import SwiftUI

// TODO: delete this View?

struct RegEmailView: View {
    @StateObject private var viewModel: RegEmailViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: RegEmailViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Enter your email")
                        .dtTypo(.h3Medium, color: .textPrimary)

                    Text("This is required to create an account")
                        .dtTypo(.p2Regular, color: .textSecondary)
                }

                VStack(spacing: 16) {
                    DtCustomTF(style: .email, input: $viewModel.email) {
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
        .padding(.bottom, 8)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .alert(
            "Wrong format of email address. Please try again!",
            isPresented: $viewModel.isWrongFormat,
            actions: {}
        )
        .hideKeyboardTapOutside()
    }
}

struct RegEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegEmailView(router: Router())
    }
}
