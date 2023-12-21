//
//  MessageBubbleView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 12.12.2023.
//

import SwiftUI

struct MessageBubbleView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: MessengerViewModel
    @State var message: MessageModel
    @State var offset: CGFloat = 0
    var scrollProxy: ScrollViewProxy
    let replyMessage: MessageModel?
    var isCurrentUser: Bool
    let style: MessageBubbleStyle

    init(viewModel: MessengerViewModel,
         message: MessageModel,
         style: MessageBubbleStyle,
         scrollProxy: ScrollViewProxy) {
        self.viewModel = viewModel
        _message = State(wrappedValue: message)
        self.replyMessage = viewModel.messages.first(where: { $0.id == message.replyMessage })
        self.isCurrentUser = viewModel.currentUser?.id == message.sender
        self.style = style
        self.scrollProxy = scrollProxy
    }

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            let attributedString = AttributedString(message.message)
            let nonBreakingSpaces = String(repeating: "\u{00A0}", count: 11)
            let mytext = attributedString + AttributedString(nonBreakingSpaces)
            VStack(alignment: .leading) {
                if let replyMessage {
                        HStack(spacing: 4) {
                            Capsule()
                                .frame(width: 2, height: 32)
                                .foregroundStyle(isCurrentUser ? Color.backgroundPrimary : Color.accentsPrimary)
                            VStack(alignment: .leading) {
                                Text((viewModel.currentUser?.id == replyMessage.sender
                                      ? viewModel.currentUser?.name
                                      : viewModel.interlocutor?.name) ?? "Message")
                                .dtTypo(.p3Medium, color: isCurrentUser ? .backgroundPrimary : .accentsPrimary)
                                Text(replyMessage.message)
                                    .dtTypo(.p4Regular, color: isCurrentUser ? .backgroundPrimary : .accentsPrimary)
                            }
                            .frame(width: .infinity)
                            .lineLimit(1)

                        }
                        .onTapGesture {
                            withAnimation {
                                scrollProxy.scrollTo(replyMessage.id, anchor: .top)
                            }

                        }
                }
                Text(mytext)
            }
            .multilineTextAlignment(.leading)
            .messageBubbleLayout(isCurrentUser: isCurrentUser,
                                 message: message,
                                 colorScheme: colorScheme,
                                 style: style)
            .contextMenu(menuItems: {
                Button("Reply") {
                    replyAction()
                }
                Button("Copy") {
                    UIPasteboard.general.string = message.message
                }
                if isCurrentUser {
                    Button("Edit") {
                        viewModel.actionMessage = message
                        viewModel.textfieldMessage = message.message
                        viewModel.actionMessageText = message.message
                        withAnimation {
                            viewModel.actionType = .edit
                        }
                    }
                }
                Button("Delete", role: .destructive) {

                }
            })
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let deltaX = value.translation.width
                        let newOffset = max(-50, min(0, deltaX))
                        withAnimation {
                            offset = newOffset
                        }

                    }
                    .onEnded { value in
                        let deltaX = value.translation.width
                        if deltaX < -50 {
                            replyAction()
                            withAnimation {
                                offset = 0
                            }
                        } else { offset = 0 }
                    }
            )

            if !isCurrentUser {
                Spacer()
            }
        }
        .id(message.id)
        .padding(isCurrentUser ? .leading : .trailing, 50)
        .padding(.horizontal, 8)
    }

    func replyAction() {
        viewModel.actionMessage = message
        viewModel.textfieldMessage = ""
        viewModel.actionMessageText = message.message
        withAnimation(.interactiveSpring) {
            viewModel.actionType = .reply
        }
    }
}

#Preview {
    MessengerView(viewModel: MessengerViewModel(),
                  interlocutor: TempUserModel.defaultUserArray.last!)
    .environmentObject(ChatViewModel(router: Router()))
}

// MARK: Message bubble layout
private struct MessageBubbleLayout: ViewModifier {
    let colorScheme: ColorScheme
    let isCurrentUser: Bool
    let message: MessageModel
    let style: MessageBubbleStyle

    func body(content: Content) -> some View {
        content
            .dtTypo(.p3Regular, color: isCurrentUser ? Color.accentsWhite : Color.textPrimary)
            .lineSpacing(5)
            .padding(.vertical, 11)
            .padding(.horizontal, 12)
            .background(backgroundColor())
            .frame(minWidth: 100, alignment: isCurrentUser ? .trailing : .leading)
            .overlay(alignment: .bottomTrailing) {
                HStack(spacing: 4) {
                    Text(DtDateFormatter.basicTime(date: message.date))
                        .dtTypo(.p5Regular, color: .iconsSecondary)
                        .colorScheme(isCurrentUser ? .dark : colorScheme)
                    if isCurrentUser {
                        statusImage
                    }
                }
                .padding(.trailing, 8)
                .padding(.bottom, 6)
            }

            .messageBubbleShape(type: isCurrentUser ? .currentUser : .interlocutor, style: style)

        //            .cornerRadius(16)
    }

    func backgroundColor() -> Color {
        isCurrentUser
        ? Color.accentsPrimary
        : (colorScheme == .light
           ? Color.backgroundPrimary
           : Color.backgroundSecondary)
    }

    var statusImage: Image {
        switch message.status {
        case .sent:
            Image(DtImage.messageSent)
        case .read:
            Image(DtImage.messageReadWhite)
        default:
            Image("")
        }
    }
}

private extension View {
    func messageBubbleLayout(isCurrentUser: Bool, message: MessageModel, colorScheme: ColorScheme, style: MessageBubbleStyle) -> some View {
        self.modifier(MessageBubbleLayout(colorScheme: colorScheme, isCurrentUser: isCurrentUser, message: message, style: style))
    }
}

// MARK: Message bubble shape
enum MessageBubbleStyle {
    case single
    case first
    case mediate
    case last
}

private enum MessageBubbleType {
    case currentUser
    case interlocutor
}

private struct MessageBubbleShape: Shape {
    var type: MessageBubbleType
    var style: MessageBubbleStyle
    let radius: CGFloat = AppConstants.Visual.cornerRadius
    let smallRadius: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()

        var topRight: CGFloat {
            switch type {
            case .interlocutor:
                radius
            case .currentUser:
                switch style {
                case .single:
                    radius
                case .first:
                    radius
                case .mediate:
                    smallRadius
                case .last:
                    smallRadius
                }
            }
        }
        let topLeftRadius = type == .interlocutor && (style == .mediate || style == .last) ? smallRadius : radius
        let topRightRadius = type == .currentUser && (style == .mediate || style == .last) ? smallRadius : radius
        let bottomLeftRadius = type == .interlocutor && (style == .mediate || style == .first) ? smallRadius : radius
        let bottomRightRadius = type == .currentUser && (style == .mediate || style == .first) ? smallRadius : radius

        path.addRoundedRect(in: rect,
                            cornerRadii: RectangleCornerRadii(topLeading: topLeftRadius,
                                                              bottomLeading: bottomLeftRadius,
                                                              bottomTrailing: bottomRightRadius,
                                                              topTrailing: topRightRadius))

        return path
    }
}

private extension View {
    func messageBubbleShape(type: MessageBubbleType, style: MessageBubbleStyle) -> some View {
        self.clipShape(MessageBubbleShape(type: type, style: style))
    }
}
