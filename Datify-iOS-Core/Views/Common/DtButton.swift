//
//  DtButton.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct DtButton: View {
    @Environment(\.colorScheme) private var colorScheme

    enum Style {
        case gradient
        case primary
        case secondary
        case main
    }

    private let title: String
    private let width: CGFloat
    private let height: CGFloat
    private let style: DtButton.Style
    private let action: () async -> Void

    init(
        title: String,
        width: CGFloat = .infinity,
        height: CGFloat = AppConstants.Visual.buttonHeight,
        style: DtButton.Style,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.width = width
        self.height = height
        self.style = style
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            switch style {
            case .gradient:
                createBody(title: title, titleColor: .accentsWhite)
                    .background(
                        colorScheme == .dark ? Color.DtGradient.brandDark : Color.DtGradient.brandLight
                    )
                    .cornerRadius(AppConstants.Visual.cornerRadius)
            case .primary:
                createBody(title: title, titleColor: .accentsWhite)
                    .buttonBackground(color: .accentsViolet)
            case .secondary:
                createBody(title: title, titleColor: .textTertiary)
                    .buttonBackground(color: .backgroundSecondary)
            case .main:
                createBody(title: title, titleColor: .accentsWhite)
                    .buttonBackground(color: .accentsPrimary)
            }
        }
        .buttonStyle(.plain)
    }

    private func createBody(
        title: String,
        titleColor: Color
    ) -> some View {
        Text(title)
            .dtTypo(.p2Medium, color: titleColor)
            .multilineTextAlignment(.center)
            .frame(maxWidth: width, minHeight: height)
    }
}

private struct ButtonBackground: ViewModifier {
    var backgroundColor: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(AppConstants.Visual.cornerRadius)
    }
}

private extension View {
    func buttonBackground(color: Color) -> some View {
        modifier(ButtonBackground(backgroundColor: color))
    }
}

struct DtButton_Previews: PreviewProvider {
    static var previews: some View {
        DtButton(title: "Button", style: .primary, action: {})
    }
}
