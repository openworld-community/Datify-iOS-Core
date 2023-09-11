//
//  DtTypography.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct DtTypography: ViewModifier {
    enum Style {
        /// Header
        case h1Medium
        case h1Regular
        case h2Medium
        case h2Regular
        case h3Medium
        case h3Regular
        case h3Semibold

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
        case .h1Medium: return content.font(.system(size: 36, weight: .medium))
        case .h1Regular: return content.font(.system(size: 36, weight: .regular))
        case .h2Medium: return content.font(.system(size: 32, weight: .medium))
        case .h2Regular: return content.font(.system(size: 32, weight: .regular))
        case .h3Medium: return content.font(.system(size: 24, weight: .medium))
        case .h3Regular: return content.font(.system(size: 24, weight: .regular))
        case .h3Semibold: return content.font(.system(size: 24, weight: .semibold))

        case .p1Medium: return content.font(.system(size: 20, weight: .medium))
        case .p1Regular: return content.font(.system(size: 20, weight: .regular))
        case .p2Medium: return content.font(.system(size: 17, weight: .medium))
        case .p2Regular: return content.font(.system(size: 17, weight: .regular))
        case .p3Medium: return content.font(.system(size: 14, weight: .medium))
        case .p3Regular: return content.font(.system(size: 14, weight: .regular))
        case .p4Medium: return content.font(.system(size: 12, weight: .medium))
        case .p4Regular: return content.font(.system(size: 12, weight: .regular))
        case .p5Medium: return content.font(.system(size: 10, weight: .medium))
        case .p5Regular: return content.font(.system(size: 10, weight: .regular))
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
