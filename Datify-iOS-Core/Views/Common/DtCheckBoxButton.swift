//
//  DtCheckBoxButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 16.10.2023.
//

import SwiftUI

struct DtCheckBoxButton: View {

    private let title: String
    private let action: () -> Void
    private let isSelected: Bool

    init(isSelected: Bool, title: String, action: @escaping () -> Void) {
        self.action = action
        self.title = title
        self.isSelected = isSelected
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Spacer()
                if isSelected {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color.accentsViolet)
                            .frame(width: 24, height: 24)
                        Image(DtImage.checkmark)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.iconsSecondary, lineWidth: 1)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: AppConstants.Visual.buttonHeight)
            .background(Color.backgroundSecondary)
            .cornerRadius(AppConstants.Visual.cornerRadius)
        }
    }
}

// #Preview {
//    DtCheckBoxButton()
// }
