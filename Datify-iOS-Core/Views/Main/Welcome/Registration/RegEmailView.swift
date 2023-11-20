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

                    Text("This is necessary to regain access to the account")
                        .dtTypo(.p2Regular, color: .textSecondary)
                }

                VStack(spacing: 4) {
                    DtCustomTF(
                        style: .email,
                        input: $viewModel.email,
                        isError: $viewModel.isWrongFormat
                    ) {
                        if !viewModel.isButtonDisabled {
                            viewModel.validateEmail()
                        }
                    }

                    if viewModel.isWrongFormat {
                        Text("Wrong format")
                            .dtTypo(.p4Regular, color: .accentsError)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
            }

            Spacer()

            HStack(spacing: 8) {
                DtBackButton {
                    viewModel.router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    // TODO: - Proceed button action
                    viewModel.validateEmail()
                }
                .disabled(viewModel.isButtonDisabled)
            }
        }
        .navigationBarBackButtonHidden()
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .hideKeyboardTapOutside()
    }
}

struct RegEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegEmailView(router: Router())
    }
}
