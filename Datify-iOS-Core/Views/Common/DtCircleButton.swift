//
//  DtCircleButton.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.11.2023.
//

import Foundation
import SwiftUI

struct DtCircleButton: View {
    @Environment(\.colorScheme) private var colorScheme
    private let systemName: String
    private let style: DtCircleButton.Style
    private let disableImage: Bool
    private let action: () async -> Void

    enum Style: CGFloat {
        case small = 48
        case big = 96
    }

    init(systemName: String, style: DtCircleButton.Style, disableImage: Bool, action: @escaping () async -> Void) {
        self.systemName = systemName
        self.style = style
        self.disableImage = disableImage
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            switch style {
            case .small:
                createBody(systemName: systemName, style: .small, disableImage: disableImage)
            case .big:
                createBody(systemName: systemName, style: .big, disableImage: disableImage)
            }
        }
        .buttonStyle(.plain)
    }

    private func createBody(
        systemName: String,
        style: DtCircleButton.Style,
        disableImage: Bool
    ) -> some View {
        Circle()
            .fill(Color.clear)
            .frame(width: style.rawValue, height: style.rawValue)
            .overlay {
                Image(systemName)
                    .renderingMode(style == .small ? .template : .original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: style.rawValue/2, height: style.rawValue/2)
                    .foregroundColor(disableImage ? Color.iconsSecondary : Color.iconsPrimary)
                    .animation(nil, value: UUID())
            }
            .background(
                RoundedRectangle(cornerRadius: style.rawValue/2)
                        .stroke(Color.iconsTertiary, lineWidth: 0.33)
            )
    }
}

struct DtCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DtCircleButton(systemName: DtImage.delete, style: .small, disableImage: true) {}
            DtCircleButton(systemName: DtImage.delete, style: .small, disableImage: false) {}
            DtCircleButton(systemName: DtImage.record, style: .big, disableImage: false) {}
            DtCircleButton(systemName: DtImage.stop, style: .big, disableImage: false) {}
            DtCircleButton(systemName: DtImage.play, style: .small, disableImage: false) {}
        }
    }
}
