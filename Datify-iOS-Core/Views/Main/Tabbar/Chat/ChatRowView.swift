//
//  ChatRowView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 20.11.2023.
//

import SwiftUI

struct ChatRowView: View {
    private let chatModel: ChatModel
    @ObservedObject var viewModel: ChatViewModel
    private let interlocutor: TempUserModel?

    init(chatModel: ChatModel, viewModel: ChatViewModel) {
        self.chatModel = chatModel
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.interlocutor = viewModel.fetchInterlocutor(for: chatModel)
    }

    var body: some View {
        if let interlocutor {
            HStack {
                let lastMessage = chatModel.messages.last
                Image(interlocutor.photoURL)
                    .resizableFill()
                    .clipShape(.circle)
                    .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(interlocutor.name + ", " + String(interlocutor.age))
                            .dtTypo(.p2Medium, color: .textPrimary)
                        if interlocutor.isOnline {
                            Circle().frame(width: 6).foregroundStyle(.green)
                        }
                        Spacer()
                        HStack {

                            switch lastMessage?.status {
                            case .sending:
                                Image(systemName: "timelapse")
                                    .resizableFit()
                                    .frame(width: 8)

                            case .sent:
                                Image(systemName: "checkmark")
                                    .resizableFit()
                                    .frame(width: 8)

                            case .received:
                                Image(systemName: "checkmark")
                                    .resizableFit()
                                    .frame(width: 8)
                                    .overlay {
                                        Image(systemName: "checkmark")
                                            .resizableFit()
                                            .frame(width: 8)
                                            .offset(x: -5)
                                    }

                            case .read:
                                Image(systemName: "checkmark")
                                    .resizableFit()
                                    .frame(width: 8)
                                    .foregroundStyle(Color.accentsBlue)
                                    .overlay {
                                        Image(systemName: "checkmark")
                                            .resizableFit()
                                            .frame(width: 8)
                                            .offset(x: -5)
                                            .foregroundStyle(Color.accentsBlue)
                                    }
                            case nil:
                                EmptyView()
                            }
                            Text(lastMessage?.dateToTimeString() ?? Date().dateToTimeString())
                                .dtTypo(.p4Medium, color: .textSecondary)
                        }
                    }

                    HStack {
                        Text(lastMessage?.message ?? "Start conversation by just saying Hello!")
                            .dtTypo(.p3Medium, color: .textSecondary)
                            .lineLimit(2)
                            .padding(.trailing, 40)
                        Spacer()
                        let unreadMessages = chatModel.messages.filter({ $0.status != .read && $0.sender == interlocutor.id }).count
                        if  unreadMessages != 0 {
                            Text(String(unreadMessages))
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
                .frame(height: 56)
            }

        }

    }
}

#Preview {
    ChatView(router: Router())
}

extension Date {
    func dateToTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
