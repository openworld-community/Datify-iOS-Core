//
//  DTGroupBoxStyle.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 01.12.2023.
//

import SwiftUI

struct DTGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .foregroundStyle(Color.backgroundPrimary)
            )
    }
}
