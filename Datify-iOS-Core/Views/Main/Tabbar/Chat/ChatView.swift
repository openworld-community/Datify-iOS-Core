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
            ForEach(viewModel.allChats) { chat in
                ChatRowView(chatModel: chat, viewModel: viewModel)
                    .listRowInsets(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .onTapGesture {
                        print(chat.messages.last?.sender ?? "No message")
                        print(chat.messages.last?.status ?? "No message")
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
