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
        self.interlocutor = viewModel.userDataService.fetchInterlocutor(for: chatModel)
    }

    var body: some View {
        if let interlocutor {
            HStack {
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

                            switch chatModel.lastMessage?.status {
                            case .sent:
                                Image(DtImage.messageSent)
                            case .read:
                                Image(DtImage.messageRead)
                            default:
                                EmptyView()
                            }
                            Text(DtDateFormatter.advancedDate(date: chatModel.lastMessage?.date ?? Date()))
                                .dtTypo(.p4Medium, color: .textSecondary)
                        }
                    }

                    HStack {
                        Text(chatModel.lastMessage?.message ?? "Start conversation by just saying Hello!")
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
                                        .foregroundStyle(Color.accentsPrimary)
                                }

                        }
                    }
                }
                .frame(height: 56)
            }
            .dtSwipeAction(rowHeight: 72, labelImage: DtImage.tabbarMenu,
                         labelText: "Delete", labelColor: Color.accentsPink) {

            }
        }

    }
}

#Preview {
    ChatView(router: Router())
}
