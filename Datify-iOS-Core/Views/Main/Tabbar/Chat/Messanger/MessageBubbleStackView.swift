//
//  MessageBubbleStackView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 19.12.2023.
//

import SwiftUI

struct MessageBubbleStackView: View {
    @ObservedObject var viewModel: MessengerViewModel
    var scrollProxy: ScrollViewProxy
    let messages: [MessageModel]

    var body: some View {
        VStack(spacing: 2) {
            if messages.count == 1 {
                if let message = messages.first {
                    MessageBubbleView(viewModel: viewModel,
                                      message: message,
                                      style: .single, scrollProxy: scrollProxy)
                }
            } else {
                if let firstMessage = messages.first {
                    MessageBubbleView(viewModel: viewModel,
                                      message: firstMessage,
                                      style: .first, scrollProxy: scrollProxy)
                }

                ForEach(mediateMessages()) { message in
                    MessageBubbleView(viewModel: viewModel,
                                      message: message,
                                      style: .mediate, scrollProxy: scrollProxy)
                }
                if let lastMessage = messages.last {
                    MessageBubbleView(viewModel: viewModel,
                                      message: lastMessage,
                                      style: .last, scrollProxy: scrollProxy)
                }
            }
        }
    }

    private func mediateMessages() -> [MessageModel] {
        var mediateMessages = messages
        mediateMessages.removeLast()
        mediateMessages.removeFirst()
        return mediateMessages
    }
}
