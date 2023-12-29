//
//  DtSelectorButton.swift
//  Datify-iOS-Core
//
//  Created by Илья on 19.09.2023.
//

import SwiftUI

struct DtSelectorButton: View {
    private var isSelected: Bool
    private let title: String
    private let action: () -> Void

    init(isSelected: Bool, title: String, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.action = action
        self.title = title
    }

    var body: some View {
        Button {
           action()
        } label: {
            HStack {
                Text(title)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Spacer()
                Circle()
                    .stroke(isSelected ? Color.accentsPrimary : Color.backgroundStroke,
                            lineWidth: isSelected ? 6 : 1)
                    .frame(width: 24)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: AppConstants.Visual.buttonHeight)
            .background(Color.backgroundSecondary)
            .cornerRadius(AppConstants.Visual.cornerRadius)
        }
    }
}

struct DtSelectorButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DtSelectorButton(isSelected: true, title: "Selector button") {}
            DtSelectorButton(isSelected: false, title: "Selector button") {}
        }
    }
}
