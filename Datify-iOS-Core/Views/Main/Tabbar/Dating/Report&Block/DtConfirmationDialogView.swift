//
//  DtConfirmationDialogView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 03.12.2023.
//

import SwiftUI

struct DtConfirmationDialogView: View {
    let onBlock: () -> Void
    let onComplain: () -> Void

    var body: some View {
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
