//
//  DtCircleButton.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.11.2023.
//

import SwiftUI

struct DtCircleButton: View {
    @Environment(\.colorScheme) private var colorScheme
    private let systemName: String
    private let style: DtCircleButton.Style
    private let disableImage: Bool
    private let action: () async -> Void

    enum Style {
        case small
        case big

        func sizeButton() -> CGFloat {
            switch self {
            case .big: return 96
            case .small: return 48
            }
        }

        func sizeIcon() -> CGFloat {
            switch self {
            case .big: return 48
            case .small: return 24
            }
        }
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
            createBody(systemName: systemName, style: style, disableImage: disableImage)
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
            .frame(width: style.sizeButton(), height: style.sizeButton())
            .overlay {
                Image(systemName)
                    .renderingMode(style == .small ? .template : .original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: style.sizeIcon(), height: style.sizeIcon())
                    .foregroundColor(disableImage ? Color.iconsSecondary : Color.iconsPrimary)
            }
            .background(
                Circle()
                    .stroke(Color.iconsTertiary, lineWidth: 0.33)
                    .frame(width: style.sizeButton(), height: style.sizeButton())
            )
    }
}

struct DtCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DtCircleButton(systemName: DtImage.delete, style: .small, disableImage: true) {}
            DtCircleButton(systemName: DtImage.delete, style: .small, disableImage: false) {}
            DtCircleButton(systemName: DtImage.record, style: .big, disableImage: false) {}
            DtCircleButton(systemName: DtImage.stopRecord, style: .big, disableImage: false) {}
            DtCircleButton(systemName: DtImage.play, style: .small, disableImage: false) {}
        }
    }
}
