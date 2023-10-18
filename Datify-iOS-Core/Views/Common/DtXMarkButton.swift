//
//  DTXMarkButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 18.10.2023.
//

import SwiftUI

struct DtXMarkButton: View {
    private let dismiss: DismissAction?
    private let action: () async -> Void
    init(dismiss: DismissAction) {
        self.dismiss = dismiss
        self.action = {}
    }
    init(action: @escaping () async -> Void) {
        self.dismiss = nil
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                if let dismiss = dismiss {
                    dismiss()
                } else { await action() }
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
