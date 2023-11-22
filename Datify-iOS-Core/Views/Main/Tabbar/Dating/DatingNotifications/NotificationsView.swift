//
//  NotificationsView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 20.10.2023.
//

import SwiftUI

struct NotificationsView: View {

    @Environment (\.dismiss) private var dismiss
    @StateObject private var viewModel: NotificationsViewModel
    @State private var showFilters: Bool = false
    @State private var blurRadius: CGFloat = 0

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: NotificationsViewModel(router: router))
    }

    var body: some View {
            VStack(spacing: 0) {
                if !(viewModel.user?.likes.filter({ $0.isNew }).isEmpty ?? true) {
                    likeSegment
                }
                if viewModel.allNotifications.isEmpty {
                    noNotificationsView
                } else {
                    ScrollView {
                        createSection(title: "Today".localize(),
                                      notificationsArray: viewModel.todayNotifications)
                        createSection(title: "Yesterday".localize(),
                                      notificationsArray: viewModel.yesterdayNotifications)
                        createSection(title: "Earlier".localize(),
                                      notificationsArray: viewModel.earlierNotifications)
                    }
                }
            }
            .task {
                viewModel.minYUpdateTimer?.invalidate()
            }
            .blur(radius: blurRadius)
            .onChange(of: showFilters) { newValue in
                withAnimation {
                    blurRadius = newValue ? 10.0 : 0
                }
            }
            .sheet(isPresented: $showFilters) {
                filterSheetView
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.viewNotofications()
                        dismiss()
                    }, label: {
                        Image(DtImage.backButton)
                            .resizableFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.primary)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showFilters.toggle()
                        }
                    }, label: {
                        Image(systemName: "gear")
                            .resizableFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.primary)
                    })
                }
            }
            .navigationBarBackButtonHidden()
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    DtSpinnerView(size: 56)
                }
            }
        }
}

#Preview {
    NavigationStack {
        NotificationsView(router: Router())
    }
}

private extension NotificationsView {

    @ViewBuilder
    func createSection(title: String,
                       notificationsArray: [NotificationModel]) -> some View {
        if !notificationsArray.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .dtTypo(.p2Medium, color: .primary)
                    .padding(.leading, 12)
                    .padding(.top, 12)

                LazyVStack(spacing: 0) {
                    ForEach(notificationsArray) { notification in
                        NotificationRowView(notification: notification, viewModel: viewModel)
                    }
                }
                Divider()
                    .padding(.horizontal)
            }
        }
    }

    var filterSheetView: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.backgroundPrimary.ignoresSafeArea()
                    VStack(spacing: 8) {
                        ForEach(NotificationsViewModel.SortOption.allCases, id: \.self) { option in
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
                            Text("Filters")
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
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.visible)
    }

    var likeSegment: some View {
        Button {
            // TODO: Like segment tap action
            // Temporary to test on device
            viewModel.viewNotofications()
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 72)
                    .foregroundStyle(Color.backgroundSpecial)
                HStack {
                    DtDoubleAvatar(user1: viewModel.getLastLikeUsers().last,
                                   user2: viewModel.getLastLikeUsers().penult)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("You have new likes!")
                            .dtTypo(.p2Medium, color: .textPrimary)
                        HStack {
                            Text("Let's see who likes you?")
                                .foregroundLinearGradient()
                                .dtTypo(.p3Regular, color: .textSecondary)
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: 22, height: 16)
                                    .foregroundStyle(Color.DtGradient.brandDark)
                                Text(String(viewModel.user?.likes.filter({$0.isNew}).count ?? 0))
                                    .dtTypo(.p4Medium, color: .accentsWhite)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }

    var noNotificationsView: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You don't have any notifications yet!")
                .dtTypo(.h3Medium, color: .textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text("Like and study the profiles of other people, so they can pay attention to your activity and show reciprocity")
                .dtTypo(.p2Regular, color: .textSecondary)
            Spacer()
            DtButton(title: "Back to acquaintance".localize(), style: .primary) {
                dismiss()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .multilineTextAlignment(.center)
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
}
