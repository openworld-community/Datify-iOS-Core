//
//  DtLogoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 29.08.2023.
//

import SwiftUI

struct DtLogoView: View {
    private let title: String = "Datify"
    var body: some View {
        HStack {
            Image("logoImage")
                .resizable()
                .frame(
                    width: 24,
                    height: 24
                )
            Text(title)
                .dtTypo(.h3Medium, color: .textPrimary)
        }
    }
}

struct DtLogoView_Previews: PreviewProvider {
    static var previews: some View {
        DtLogoView()
    }
}
