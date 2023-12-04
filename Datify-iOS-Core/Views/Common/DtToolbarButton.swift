//
//  DtToolbarButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 28.11.2023.
//

import SwiftUI

@ToolbarContentBuilder
func dtToolbarButton(placement: ToolbarItemPlacement,
                     image: String,
                     action: @escaping () -> Void) -> some ToolbarContent {
    ToolbarItem(placement: placement) {
        Button {
            action()
        } label: {
            Image(image)
                .resizableFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.textPrimary)
        }
    }
}
