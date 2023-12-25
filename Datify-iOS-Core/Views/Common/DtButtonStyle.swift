//
//  DtButtonStyle.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 02.12.2023.
//

import SwiftUI

struct DtButtonStyle: ButtonStyle {
    let backgroundColorNormal: Color
    let backgroundColorWhenPressed: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? backgroundColorWhenPressed : backgroundColorNormal)
    }
}

#Preview {
    Button {
    } label: {
        Text("Bla bla")
            .padding()
    }
    .buttonStyle(
        DtButtonStyle(
            backgroundColorNormal: .red,
            backgroundColorWhenPressed: .orange)
    )
}
