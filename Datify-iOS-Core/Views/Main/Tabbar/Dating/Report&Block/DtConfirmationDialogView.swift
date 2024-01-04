//
//  DtConfirmationDialogView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 03.12.2023.
//

import SwiftUI

struct DtConfirmationDialogView: View {
    @Binding var isPresented: Bool
    let onBlock: () -> Void
    let onComplain: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            GroupBox {
                VStack(spacing: 0) {
                    Button {
                        onBlock()
                    } label: {
                        Text("Block")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                    .dtTypo(.p2Medium, color: .textPrimary)

                    Divider()

                    Button {
                        onComplain()
                    } label: {
                        Text("Complain")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                    .dtTypo(.p2Medium, color: .accentsPink)
                }
            }
            .groupBoxStyle(DtGroupBoxStyle())
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius))

            GroupBox {
                Button(role: .cancel) {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .dtTypo(.p2Medium, color: .textPrimary)
            }
            .groupBoxStyle(DtGroupBoxStyle())
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius))
        }
        .padding(.horizontal, 24)
        .padding(.vertical)
    }
}

#Preview {
    DtConfirmationDialogView(isPresented: .constant(true), onBlock: {}, onComplain: {})
        .background(Color.gray)
}
