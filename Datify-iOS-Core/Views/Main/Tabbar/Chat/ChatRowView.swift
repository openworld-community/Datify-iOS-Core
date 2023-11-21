//
//  ChatRowView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 20.11.2023.
//

import SwiftUI

struct ChatRowView: View {
    let chatModel: ChatModel

    var body: some View {
        HStack {
            Image(chatModel.chatUser.photoURL)
                .resizableFill()
                .clipShape(.circle)
                .frame(width: 56, height: 56)
            VStack(alignment: .leading) {
                HStack {
                    Text(chatModel.chatUser.name + ", " + String(chatModel.chatUser.age))
                        .dtTypo(.p2Medium, color: .textPrimary)
                    if chatModel.chatUser.isOnline {
                        Circle().frame(width: 6).foregroundStyle(.green)
                    }
                    Spacer()
                    Text(chatModel.messages.last?.dateToTimeString() ?? Date().dateToTimeString())
                        .dtTypo(.p4Medium, color: .textSecondary)
                }

                HStack {
                    Text(chatModel.messages.last?.message ?? "Meow me hard, as hard as you can i know you want it you dirty pervert")
                        .dtTypo(.p3Medium, color: .textSecondary)
                        .lineLimit(2)
                        .padding(.trailing, 40)
                    Spacer()
                    Text(String(chatModel.messages.filter({ $0.isRead }).count))
                        .dtTypo(.p4Medium, color: .accentsWhite)
                        .padding(.horizontal, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .frame(height: 16)
                                .foregroundStyle(Color.DtGradient.brandDark)
                        }
                }
            }
        }
    }
}

#Preview {
    ChatRowView(chatModel: ChatModel(chatUser: TempUserModel(id: "1",
                                                             name: "Alexandra",
                                                             age: 21,
                                                             isOnline: true,
                                                             photoURL: "AvatarPhoto")))
}

extension Date {
    func dateToTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
