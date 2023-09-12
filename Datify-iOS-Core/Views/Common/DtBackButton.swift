//
//  DtBackButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 11.09.2023.
//

import SwiftUI

struct DtBackButton: View {

    private let size: CGFloat
    private let action: () async -> Void

    init(
        size: CGFloat = AppConstants.Visual.buttonHeight,
        action: @escaping () async -> Void
    ) {
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(DtImage.backButton)
                .resizableFit()
                .padding()
                .frame(width: size,
                       height: size)
                .background(Color.backgroundSecondary)
                .cornerRadius(AppConstants.Visual.cornerRadius)
        }
    }
}

struct DtBackButton_Previews: PreviewProvider {
    static var previews: some View {
        DtBackButton(action: {})
    }
}
