//
//  DtMenuButton.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 29.12.2023.
//

import SwiftUI

struct DtMenuShortButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(icon)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.backgroundSecondary)
            .cornerRadius(16)
        }

    }
}

#Preview {
    HStack {
        DtMenuShortButton(icon: "menuHeart", title: "likes") { }
        DtMenuShortButton(icon: "menuNotification", title: "notifications") { }
        DtMenuShortButton(icon: "menuProfile", title: "profile") { }
    }
}
