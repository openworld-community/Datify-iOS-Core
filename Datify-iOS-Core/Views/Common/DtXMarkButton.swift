//
//  DTXMarkButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 18.10.2023.
//

import SwiftUI

struct DtXMarkButton: View {
    @Environment(\.dismiss) private var dismiss
    private let action: () async -> Void

    init(action: @escaping () async -> Void = {}) {
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                await action()
                dismiss()
            }
        } label: {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.backgroundSecondary)
                Image(DtImage.xmark)
            }
        }
    }
}
