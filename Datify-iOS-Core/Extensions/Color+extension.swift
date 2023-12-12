//
//  Color+extension.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 08) & 0xFF) / 255,
            blue: Double((hex >> 00) & 0xFF) / 255,
            opacity: alpha
        )
    }

    static let backgroundPrimary: Color = Color("BackgroundPrimary")
    static let backgroundSecondary: Color = Color("BackgroundSecondary")
    static let backgroundStroke: Color = Color("BackgroundStroke")

    static let iconsPrimary: Color = Color("IconsPrimary")
    static let iconsSecondary: Color = Color("IconsSecondary")
    static let iconsTertiary: Color = Color("IconsTertiary")

    static let accentsBlue: Color = Color("AccentsBlue")
    static let accentsError: Color = Color("AccentsError")
    static let accentsGreen: Color = Color("AccentsGreen")
    static let accentsPink: Color = Color("AccentsPink")
    static let accentsViolet: Color = Color("AccentsViolet")
    static let accentsYellow: Color = Color("AccentsYellow")
    static let accentsBlack: Color = Color("AccentsBlack")
    static let accentsPrimary: Color = Color("AccentsPrimary")
    static let accentsWhite: Color = Color("AccentsWhite")

    static let textInverted: Color = Color("TextInverted")
    static let textPrimary: Color = Color("TextPrimary")
    static let textSecondary: Color = Color("TextSecondary")
    static let textTertiary: Color = Color("TextTertiary")
    static let textPrimaryLink: Color = Color("TextPrimaryLink")

    enum DtGradient {
        static let brandLight = LinearGradient(
            colors: [
                Color(hex: 0x4315AC),
                Color(hex: 0x9049D4),
                Color(hex: 0xDD60D8),
                Color(hex: 0xED75BD),
                Color(hex: 0xFF80AC)
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        )
        static let brandDark = LinearGradient(
            colors: [
                Color(hex: 0x7B41FF),
                Color(hex: 0xAB63F3),
                Color(hex: 0xDD60D8),
                Color(hex: 0xED75BD),
                Color(hex: 0xFF80AC)
            ],
            startPoint: UnitPoint(x: 0, y: 0.5),
            endPoint: UnitPoint(x: 1, y: 0.5)
        )
    }
}

extension Color {
    static let customBlack = Color.black
    static let customWhite = Color.white
    static let customGray = Color(red: 114/255, green: 114/255, blue: 114/255)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 6: a = 255; r = int >> 16; g = int >> 8 & 0xFF; b = int & 0xFF
            case 8: a = int >> 24; r = int >> 16 & 0xFF; g = int >> 8 & 0xFF; b = int & 0xFF
            default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    var redComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[0])
        }
        return 0.0
    }

    var greenComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[1])
        }
        return 0.0
    }

    var blueComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[2])
        }
        return 0.0
    }
}
