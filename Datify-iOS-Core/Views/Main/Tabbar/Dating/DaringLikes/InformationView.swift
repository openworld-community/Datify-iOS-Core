//
//  RestoreChatSheetView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 07.12.2023.
//

import SwiftUI

struct InformationView: View {
    @Binding private var showView: Bool
    private var widthScreen: CGFloat
    private var title: String
    private var text: String
    private var titleButton: String
    private var action: () -> Void

    init(showView: Binding<Bool>,
         widthScreen: CGFloat,
         title: String,
         text: String,
         titleButton: String,
         action: @escaping () -> Void) {
        _showView = showView
        self.widthScreen = widthScreen
        self.title = title
        self.text = text
        self.titleButton = titleButton
        self.action = action
    }

    var body: some View {
        if showView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 56, height: 56)
                        .foregroundColor(.green)
                    Image(DtImage.exclamationPoint)
                        .resizableFill()
                        .frame(width: 32, height: 32)
                }
                .shadow(radius: 6, y: 5)
                .padding(.vertical)
                Text(title)
                    .dtTypo(.p2Medium, color: .textPrimary)
                    .padding(.bottom, 7)
                Text(text)
                    .dtTypo(.p3Medium, color: .textTertiary)
                    .multilineTextAlignment(.center)
                    .padding([.horizontal, .bottom])
                DtButton(title: titleButton, style: .main, action: {
                    action()
                })
                .padding(.bottom)
            }
            .padding()
            .frame(width: widthScreen * 0.98)
            .background(Color.backgroundPrimary)
            .cornerRadius(32)
        }
    }
}

#Preview {
    InformationView(showView: .constant(true),
                    widthScreen: 390,
                    title: "Restore chat?",
                    text: "The chat with this user has been deleted, are you sure you want to restore it?",
                    titleButton: "Yes, restore") {
        print("tap")
    }
}
