//
//  PasswordView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.11.2023.
//

import SwiftUI

struct PasswordView: View {
    unowned let router: Router<AppRoute>

    var body: some View {
        VStack {
            Spacer()

            Text("Password View")
                .dtTypo(.h1Medium, color: .textPrimary)

            Spacer()

            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Proceed".localize(), style: .main) {
                    // TODO: - Proceed button action
                    router.push(.registrationLocation)
                }
            }
            .padding(.bottom)
            .navigationBarBackButtonHidden()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PasswordView(router: Router())
    }
}
