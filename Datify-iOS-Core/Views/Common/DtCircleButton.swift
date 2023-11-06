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
    private let disable: Bool
    private let action: () async -> Void

    enum Style: CGFloat {
        case small = 48
        case big = 96
    }

    init(systemName: String, style: DtCircleButton.Style, disable: Bool, action: @escaping () async -> Void) {
        self.systemName = systemName
        self.style = style
        self.disable = disable
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
                createBody(systemName: systemName, style: .small, disable: disable)
            case .big:
                createBody(systemName: systemName, style: .big, disable: disable)
            }
        }
        .buttonStyle(.plain)
    }

    private func createBody(
        systemName: String,
        style: DtCircleButton.Style,
        disable: Bool
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
                    .foregroundColor(disable ? Color.iconsSecondary : Color.iconsPrimary)
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
            DtCircleButton(systemName: DtImage.delete, style: .small, disable: true) {}
            DtCircleButton(systemName: DtImage.delete, style: .small, disable: false) {}
            DtCircleButton(systemName: DtImage.record, style: .big, disable: false) {}
            DtCircleButton(systemName: DtImage.stop, style: .big, disable: false) {}
            DtCircleButton(systemName: DtImage.play, style: .small, disable: false) {}
        }
    }
}