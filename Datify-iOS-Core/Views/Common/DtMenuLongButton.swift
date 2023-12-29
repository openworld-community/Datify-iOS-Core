//
//  DtMenuLongButton.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 29.12.2023.
//

import SwiftUI

struct DtMenuLongButton: View {
    let icon: String
    let titleOne: String
    let titleTwo: String?
    let height: CGFloat
    let action: () -> Void

    init(icon: String, titleOne: String, titleTwo: String? = nil, height: CGFloat, action: @escaping () -> Void) {
        self.icon = icon
        self.titleOne = titleOne
        self.titleTwo = titleTwo
        self.height = height
        self.action = action
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(icon)
                    .padding(.horizontal, 5)
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleOne)
                        .dtTypo(.p2Regular, color: .customBlack)
                    if let titleTwo {
                        Text(titleTwo)
                            .dtTypo(.p2Regular, color: .customGray)
                    }
                }
                Spacer()
                Image("forwardArrow")
                    .padding(.horizontal, 5)
            }
            .frame(height: height)
            .background(Color.backgroundSecondary)
        }
    }
}

#Preview {
    VStack {
        DtMenuLongButton(icon: "accountManagement", titleOne: "Account management", height: 50) { }
        DtMenuLongButton(icon: "accountManagement", titleOne: "Account management", titleTwo: "+7 (951) 432 474 22", height: 70) { }
    }
}
