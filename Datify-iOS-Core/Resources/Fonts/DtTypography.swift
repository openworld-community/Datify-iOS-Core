//
//  DtTypography.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

private enum DtFont: String {
    case regular = "SF-Pro-Display-Regular"
    case medium = "SF-Pro-Display-Medium"
}

struct DtTypography: ViewModifier {
    enum Style {
        /// Header
        case h1Medium
        case h1Regular
        case h2Medium
        case h2Regular
        case h3Medium
        case h3Regular

        /// Paragraph
        case p1Medium
        case p1Regular
        case p2Medium
        case p2Regular
        case p3Medium
        case p3Regular
        case p4Medium
        case p4Regular
        case p5Medium
        case p5Regular
    }

    var style: Style

    // swiftlint:disable cyclomatic_complexity
    public func body(content: Content) -> some View {
        switch style {
        case .h1Medium: return content.font(.custom(DtFont.medium.rawValue, size: 36))
        case .h1Regular: return content.font(.custom(DtFont.regular.rawValue, size: 36))
        case .h2Medium: return content.font(.custom(DtFont.medium.rawValue, size: 32))
        case .h2Regular: return content.font(.custom(DtFont.regular.rawValue, size: 32))
        case .h3Medium: return content.font(.custom(DtFont.medium.rawValue, size: 24))
        case .h3Regular: return content.font(.custom(DtFont.regular.rawValue, size: 24))

        case .p1Medium: return content.font(.custom(DtFont.medium.rawValue, size: 20))
        case .p1Regular: return content.font(.custom(DtFont.regular.rawValue, size: 20))
        case .p2Medium: return content.font(.custom(DtFont.medium.rawValue, size: 17))
        case .p2Regular: return content.font(.custom(DtFont.regular.rawValue, size: 17))
        case .p3Medium: return content.font(.custom(DtFont.medium.rawValue, size: 14))
        case .p3Regular: return content.font(.custom(DtFont.regular.rawValue, size: 14))
        case .p4Medium: return content.font(.custom(DtFont.medium.rawValue, size: 12))
        case .p4Regular: return content.font(.custom(DtFont.regular.rawValue, size: 12))
        case .p5Medium: return content.font(.custom(DtFont.medium.rawValue, size: 10))
        case .p5Regular: return content.font(.custom(DtFont.regular.rawValue, size: 10))
        }
    }
}

extension View {
    func dtTypo(
        _ style: DtTypography.Style,
        color: Color
    ) -> some View {
        modifier(DtTypography(style: style))
            .foregroundColor(color)
    }
}
