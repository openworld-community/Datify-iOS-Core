//
//  ChatView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var showSheet: Bool = false
    @State private var blurRadius: CGFloat = 0

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(router: router))
    }

    var body: some View {
        switchState(loadingState: viewModel.loadingState)
            .sheet(isPresented: $showSheet, content: {
                filterSheetView
            })
            .blur(radius: blurRadius)
            .task {
                try? await viewModel.loadData()
            }
            .alert("Some error occured", isPresented: $viewModel.isError) {
                Button("Ok") {
                    viewModel.resetState()
                }
            }
            .navigationBarBackButtonHidden()
    }
}

private extension ChatView {
    @ViewBuilder
    func switchState(loadingState: LoadingState) -> some View {
        switch loadingState {
        case .success:
            VStack {
                topToolbar
                chatsScrollView
            }
        default: DtSpinnerView(size: 56)
        }
    }

    var filterSheetView: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.backgroundPrimary.ignoresSafeArea()
                    VStack(spacing: 8) {
                        ForEach(ChatViewModel.SortOption.allCases, id: \.self) { option in
                            DtSelectorButton(isSelected: viewModel.sortOption == option, title: option.title) {
                                viewModel.sortOption = option
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            DtXMarkButton()
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Sort chats")
                                .dtTypo(.h3Medium, color: .textPrimary)
                        }
                    }
                }
                .onChange(of: geometry.frame(in: .global).minY) { minY in
                    withAnimation {
                        blurRadius = interpolatedValue(for: minY)
                    }
                }
            }
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.visible)
    }

    func interpolatedValue(for height: CGFloat) -> CGFloat {
        // TODO: Replace with View extension
        let screenHeight = UIScreen.main.bounds.height
        let startHeight = screenHeight
        let endHeight = screenHeight - 350
        let startValue: CGFloat = 0.0
        let endValue: CGFloat = 10.0

        if height >= startHeight || height <= 100 {
            return startValue
        } else if height <= endHeight {
            return endValue
        }

        let slope = (endValue - startValue) / (endHeight - startHeight)
        return startValue + slope * (height - startHeight)
    }

    var topToolbar: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundStyle(Color.textPrimary)
            Spacer()
            Text("Chats")
            Spacer()
            Button {

            } label: {
                Image(DtImage.search)
            }
        }
        .frame(height: 32)
        .padding(.horizontal, 12)
    }

    var likesSegment: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                if let user = viewModel.currentUser {
                    HStack {
                        // Если переходим на iOS 17 - заменить на safeArea
                        Color.clear
                            .frame(width: 4)
                        ForEach(user.likes) { likeModel in
                            LikeCircleView(
                                user: viewModel
                                    .userDataService
                                    .getUserForID(for: likeModel.senderId),
                                isNew: likeModel.isNew)
                        }
                    }
                }
            }
            .frame(height: 80)
        }
    }

    var chatsScrollView: some View {
        ScrollView {
            likesSegment
            HStack {
                Text("Messages")
                    .dtTypo(.p2Medium, color: .textPrimary)
                Spacer()
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 24)
            VStack(spacing: 0) {
                Divider()
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.sortedChats) { chat in
                        VStack(spacing: 0) {
                            ChatRowView(chatModel: chat, viewModel: viewModel)
                                .frame(height: 72)
                            Divider()
                                .padding(.leading, 72)
                        }
                    }
                }
            }

        }
    }

    var listView: some View {
            chatsScrollView
    }
}

#Preview {
    NavigationStack {
        ChatView(router: Router())
    }
}
