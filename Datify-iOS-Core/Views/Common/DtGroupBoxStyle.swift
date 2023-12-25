//
//  DtGroupBoxStyle.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 01.12.2023.
//

import SwiftUI

struct DtGroupBoxStyle: GroupBoxStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .fill(Color.backgroundPrimary)
            )
            .buttonStyle(
                DtButtonStyle(
                    backgroundColorNormal: colorScheme == .light ?
                                           Color.backgroundPrimary :
                                           Color(hex: 0x1C1C1F),
                    backgroundColorWhenPressed: colorScheme == .light ?
                                                Color(hex: 0xEFEFF0) :
                                                Color(hex: 0x27272A))
            )
    }
}
