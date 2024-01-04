//
//  ConfirmBlockView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 02.12.2023.
//

import SwiftUI

struct ConfirmationView: View {
    enum ConfirmationType {
        case block, complain
    }

    let confirmationType: ConfirmationType
    let onConfirm: () -> Void

    var body: some View {
        Group {
            switch confirmationType {
            case .block:
                ZStack(alignment: .top) {
                    Image("flowerIcon")
                        .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

                    getDescription()
                }
            case .complain:
                VStack(spacing: 16) {
                    ZStack {
                        Color.accentsGreen
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)

                    }
                    .frame(width: 48, height: 48)
                    .clipped()
                    .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

                    getDescription()
                }
            }
        }
        .padding(
            EdgeInsets(
                top: confirmationType == .block ? 20 : 32,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
        .background(
            Color.backgroundPrimary
                .mask(RoundedRectangle(cornerRadius: 32, style: .continuous))
        )
        .padding(8)
    }

    private func getDescription() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text(
                    confirmationType == .block ?
                    "User successfully blocked" :
                    "Thank you for your appeal!"
                )
                .dtTypo(.h3Medium, color: .textPrimary)
                .multilineTextAlignment(.center)
                Text(
                    confirmationType == .block ?
                    "Thanks for the appeal, now this user won't bother you anymore" :
                    "We will look into it as soon as possible and take steps to make sure it doesn't happen again"
                )
                    .dtTypo(.p2Regular, color: .textSecondary)
                    .multilineTextAlignment(.center)
            }

            DtButton(
                title: "Got it".localize(),
                style: .main
            ) {
                Task { @MainActor in
                    onConfirm()
                }
            }
        }
        .padding(.top, confirmationType == .block ? 90 : 0)
    }
}

#Preview {
    ConfirmationView(
        confirmationType: .complain,
        onConfirm: {}
    )
    .background(Color.gray)
}

#Preview {
    ConfirmationView(
        confirmationType: .block,
        onConfirm: {}
    )
    .background(Color.gray)
}
