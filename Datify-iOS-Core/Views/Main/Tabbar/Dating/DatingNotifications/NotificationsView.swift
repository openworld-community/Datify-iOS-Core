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
        switchState(loadingState: viewModel.loadingState)
            .task {
                viewModel.minYUpdateTimer?.invalidate()
                do {
                    try await viewModel.loadData()
                } catch {
                    viewModel.loadingState = .error
                    viewModel.isError = true
                }
            }
            .alert("Some error occured", isPresented: $viewModel.isError) {
                Button("Ok") {
                    viewModel.loadingState = .idle
                }
            }

            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                dtToolbarButton(placement: .topBarLeading, image: DtImage.backButton) {
                    viewModel.viewNotifications()
                    dismiss()
                }
                // TODO: Replace with image from assets
                dtToolbarButton(placement: .topBarTrailing, image: DtImage.arrowRight) {
                    withAnimation {
                        showFilters.toggle()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .overlay(alignment: .center) {
                if viewModel.loadingState == .loading {
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
    func switchState(loadingState: LoadingState) -> some View {
        switch loadingState {
        case .success:
            VStack(spacing: 0) {
                if !(viewModel.user?.newLikes.isEmpty ?? true) {
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
            .blur(radius: blurRadius)
            .onChange(of: showFilters) { newValue in
                withAnimation {
                    blurRadius = newValue ? 10.0 : 0
                }
            }
            .sheetFilter(isPresented: $showFilters, title: "Filters", content: {
                FilterView(sortOption: $viewModel.sortOption)
            })
        default: DtSpinnerView(size: 56)
        }
    }

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

    var likeSegment: some View {
        Button {
            // TODO: Like segment tap action
            // Temporary to test on device
            viewModel.viewNotifications()
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 72)
                    .foregroundStyle(Color.backgroundSpecial)
                HStack {
                    DtUserCircleImage.doubleUserImage(user1: viewModel.getLastLikeUsers().last,
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
                                Text(String(viewModel.user?.newLikes.count ?? 0))
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
