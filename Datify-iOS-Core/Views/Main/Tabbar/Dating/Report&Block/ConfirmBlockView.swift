//
//  ConfirmBlockView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 02.12.2023.
//

import SwiftUI

struct ConfirmBlockView: View {
    let onConfirm: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Image("flowerIcon")
                .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("User successfully blocked")
                        .dtTypo(.h3Medium, color: .textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Thanks for the appeal, now this user won't bother you anymore").dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }

                DtButton(
                    title: "Got it",
                    style: .main) {
                        onConfirm()
                    }
            }
            .padding(.top, 90)
        }
        .padding(
            EdgeInsets(
                top: 20,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
    }
}

#Preview {
    ConfirmBlockView(onConfirm: {})
}
