//
//  DtLogoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 29.08.2023.
//

import SwiftUI

struct DtLogoView: View {
    private let title: String = "Datify"
    private let blackAndWhiteColor: Bool
    private let fontTextColor: Color

    init() {
        self.blackAndWhiteColor = false
        self.fontTextColor = .textTertiary
    }

    init(blackAndWhiteColor: Bool, fontTextColor: Color) {
        self.blackAndWhiteColor = blackAndWhiteColor
        self.fontTextColor = fontTextColor
    }

    var body: some View {
        HStack {
            if !blackAndWhiteColor {
                Image("logoImageBrand")
                    .resizable()
                    .frame(
                        width: 24,
                        height: 24
                    )
            } else {
                Image("logoImageBrandBW")
                    .resizable()
                    .frame(
                        width: 24,
                        height: 24
                    )
            }
            Text(title)
                .dtTypo(.h3Semibold, color: fontTextColor)
        }
    }
}

struct DtLogoView_Previews: PreviewProvider {
    static var previews: some View {
        DtLogoView()
    }
}
