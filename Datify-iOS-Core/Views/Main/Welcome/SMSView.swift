//
//  SMSView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.11.2023.
//

import SwiftUI

struct SMSView: View {
    unowned let router: Router<AppRoute>

    var body: some View {
        VStack {
            Spacer()

            Text("SMS View")
                .dtTypo(.h1Medium, color: .textPrimary)

            DtButton(title: "Login", style: .gradient) {
                router.push(.login)
            }

            DtButton(title: "Registration", style: .gradient) {
                router.push(.registrationSex)
            }

            Spacer()

            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    // TODO: - Proceed button action
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
        SMSView(router: Router())
    }
}
