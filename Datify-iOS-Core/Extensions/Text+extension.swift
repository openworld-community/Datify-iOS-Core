//
//  Text+extension.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

extension Text {
    func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self
            )
        }
    }
    func foregroundLinearGradient(gradient: LinearGradient = Color.DtGradient.brandLight) -> some View {
        self.overlay {
            gradient
            .mask(
                self
            )
        }
    }
}
