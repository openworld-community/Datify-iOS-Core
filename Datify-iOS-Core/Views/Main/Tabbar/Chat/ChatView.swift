//
//  ChatView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(router: router))
    }

    var body: some View {

            List {
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        Text("Likes")
                            .dtTypo(.p2Medium, color: .textPrimary)
                        Spacer()
                        Button(action: {}, label: {
                            Text("Show all")
                                .dtTypo(.p3Medium, color: .accentsPink)
                        })
                    }
                    .padding(.horizontal, 12)
                    ScrollView(.horizontal, showsIndicators: false) {
                        if let user = viewModel.user {
                            HStack {
                                // Если переходим на iOS 17 - заменить на safeArea
                                Color.clear
                                    .frame(width: 4)
                                ForEach(user.likes) { likeModel in
                                    LikeCircleView(user: viewModel.fetchUserForID(for: likeModel.senderId))
                                }
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 6, leading: 0, bottom: 6, trailing: 0))

                Section {
                    HStack {
                        Text("Messages")
                            .dtTypo(.p2Medium, color: .textPrimary)
                        Spacer()
                        Image(systemName: "slider.horizontal.3")
                    }
                    .listRowInsets(.init(top: 6, leading: 12, bottom: 6, trailing: 12))

                    ForEach(viewModel.allChats) { chat in
                        ChatRowView(chatModel: chat, viewModel: viewModel)
                            .listRowInsets(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .onTapGesture {
                                print(chat.messages.last?.sender ?? "No message")
                                print(chat.messages.last?.status ?? "No message")
                            }
                    }
                }

            }

            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.fill")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }
            }
            .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.inline)

    }
}

#Preview {
    NavigationStack {
        ChatView(router: Router())
    }
}
