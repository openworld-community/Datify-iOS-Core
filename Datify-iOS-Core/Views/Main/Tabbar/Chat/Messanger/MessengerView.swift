//
//  MessangerView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 12.12.2023.
//

import SwiftUI

struct MessengerView: View {
    @Environment (\.colorScheme) var colorScheme
    @StateObject var viewModel: MessengerViewModel
    @State var messageText: String = ""
    @State var isAtBottom: Bool = true
    @State var isTextfieldEmpty: Bool = true
    @FocusState private var isTextFieldFocused: Bool

    let interlocutor: TempUserModel
    var body: some View {
        VStack {
            topToolbar
            messengerSegment
            textfieldActionBar()
            textfieldSegment
        }
        .onChange(of: viewModel.actionType) { newValue in
            isTextFieldFocused = newValue == nil ? false : true
        }
    }
}

private extension MessengerView {

    var topToolbar: some View {
        ZStack {
            VStack {
                Text(interlocutor.name + ", " + String(interlocutor.age))
                    .dtTypo(.p2Medium, color: .textPrimary)
                Text(interlocutor.isOnline ? "Is online" : "Seen recently")
                    .dtTypo(.p4Regular, color: .textSecondary)
            }
            HStack {
                Button {} label: {
                    Image(DtImage.backButton)
                }
                Spacer()
                Button {} label: {
                    Image(interlocutor.photoURL)
                        .resizableFill()
                        .frame(width: 32)
                        .clipShape(Circle())
                }
            }
        }
        .frame(height: 32)
        .padding(.horizontal, 12)
    }

    var messengerSegment: some View {
        GeometryReader { messengerGeo in
            ZStack {
                colorScheme == .light ? Color.backgroundSecondary : Color.backgroundPrimary
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(spacing: 8) {
                            Spacer(minLength: 4)
                                .id("top")
                            ForEach(viewModel.groupMessagesByUser(), id: \.self) { messages in
                                MessageBubbleStackView(viewModel: viewModel,
                                                       scrollProxy: scrollViewProxy,
                                                       messages: messages)
                            }
                            GeometryReader { geometry in
                                Spacer()
                                    .frame(height: 1)
                                    .id("bottom")
                                    .onChange(of: geometry.frame(in: .global).minY) { minY in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isAtBottom = minY < 1.2 * messengerGeo.size.height
                                        }
                                    }
                            }
                        }
                    }
                    .onAppear {
                        scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            withAnimation {
                                scrollViewProxy.scrollTo("bottom", anchor: .bottom)
                            }
                        } label: {
                            Circle()
                                .frame(width: 32)
                                .foregroundStyle(Color.accentsPrimary)
                                .opacity(0.8)
                                .overlay {
                                    Image("iconArrowBottom")
                                        .blendMode(.plusLighter)
                                        .offset(y: 2)
                                }
                                .scaleEffect(isAtBottom ? 0.0 : 1.0)
                        }
                        .offset(x: -8, y: -8)
                        .allowsHitTesting(!isAtBottom)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func textfieldActionBar() -> some View {
        if let actionType = viewModel.actionType {
            HStack {
                Image(actionType == .edit ? DtImage.messageEdit : DtImage.messageRespond)
                    .frame(width: 24, height: 24)
                Capsule()
                    .frame(width: 2, height: 32)
                    .foregroundStyle(Color.accentsPrimary)
                VStack(alignment: .leading) {
                    Text(actionType == .edit ? "Editing" : "Replying")
                        .dtTypo(.p3Medium, color: .accentsPrimary)
                    Text(viewModel.actionMessageText)
                        .dtTypo(.p3Regular, color: .textPrimary)
                        .lineLimit(1)
                }
                Spacer()
                Button {
                    viewModel.textfieldMessage = ""
                    viewModel.actionMessageText = ""
                    withAnimation {
                        viewModel.actionType = nil
                    }

                } label: {Image(DtImage.messageXMark)}

            }
            .padding(.horizontal, 12)
            .frame(height: 40)
        }
    }

    var textfieldSegment: some View {
        HStack(alignment: .bottom) {
            Button {} label: {
                Image(DtImage.messageAdd)
                    .frame(height: 40)
            }
            TextField("", text: $viewModel.textfieldMessage, axis: .vertical)
                .focused($isTextFieldFocused)
                .padding(.horizontal, 12)
                .dtTypo(.p2Regular, color: .textPrimary)
                .lineLimit(10)
                .padding(4)
                .frame(minHeight: 40)
                .background(Color.backgroundSecondary)
                .cornerRadius(20)
                .overlay(alignment: .leading) {
                    if viewModel.textfieldMessage.isEmpty {
                        Text("Message")
                            .dtTypo(.p2Regular, color: .textSecondary)
                        .padding(.leading, 16)
                    }
                }
                .onChange(of: viewModel.textfieldMessage) { newValue in
                    withAnimation {
                        isTextfieldEmpty = newValue != "" ? false : true
                    }
                }

            if isTextfieldEmpty {
                Button {
                    withAnimation(.snappy) {

                    }
                } label: {
                    Image(DtImage.messageVoice)
                        .frame(width: 40, height: 40)
                }
            } else {
                Button {
                    switch viewModel.actionType {
                    case .reply:
                        viewModel.actionType = nil
                        viewModel.actionMessageText = ""
                        viewModel.textfieldMessage = ""
                    case .edit:
                        viewModel.actionType = nil
                        viewModel.actionMessageText = ""
                        viewModel.textfieldMessage = ""
                    default:
                        viewModel.textfieldMessage = ""
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 40)
                            .foregroundStyle(Color.accentsPrimary)
                        Image(DtImage.messageSend)
                    }
                }
            }
        }
        .padding(.top, 2)
        .padding(.horizontal, 12)
    }
}

#Preview {
    MessengerView(viewModel: MessengerViewModel(),
                  interlocutor: TempUserModel.defaultUserArray.last!)
        .environmentObject(ChatViewModel(router: Router()))
}
