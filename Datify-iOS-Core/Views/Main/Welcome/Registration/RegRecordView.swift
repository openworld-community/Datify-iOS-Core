//
//  RegRecordView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.11.2023.
//

import SwiftUI

struct RegRecordView: View {
    unowned let router: Router<AppRoute>

    var body: some View {
        VStack {
            Spacer()

            Text("RegRecord View")
                .dtTypo(.h1Medium, color: .textPrimary)

            Spacer()

            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    // TODO: - Proceed button action
                    router.push(.registrationFinish)
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
        RegRecordView(router: Router())
    }
}
