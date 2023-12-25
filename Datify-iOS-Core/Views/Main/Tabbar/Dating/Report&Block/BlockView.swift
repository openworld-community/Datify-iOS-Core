//
//  BlockView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 02.12.2023.
//

import SwiftUI

struct BlockView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Color.accentsPink
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)

            }
            .frame(width: 48, height: 48)
            .clipped()
            .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("Do you want to block this user?")
                        .dtTypo(.h3Medium, color: .textPrimary)
                        .multilineTextAlignment(.center)
                    Text("The user will be blocked and will no longer be able to find your profile on Datify")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 8) {
                    DtButton(
                        title: "Yes, block".localize(),
                        style: .main
                    ) {
                        onConfirm()
                    }
                    DtButton(
                        title: "No, cancel".localize(),
                        style: .picker
                    ) {
                        onCancel()
                    }
                }
            }
        }
        .padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
    }
}

#Preview {
    BlockView(onConfirm: {}, onCancel: {})
}
