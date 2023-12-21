//
//  NotificationRowVIew.swift
//  Datify-iOS-Core
//
//  Created by Илья on 20.10.2023.
//

import SwiftUI

struct NotificationRowView: View {
    @Environment (\.colorScheme) private var colorScheme
    @ObservedObject private var viewModel: NotificationsViewModel
    private let notification: NotificationModel
    private var sender: TempUserModel?
    @State private var debouncedMinY: CGFloat = 0

    init(notification: NotificationModel, viewModel: NotificationsViewModel) {
        self.notification = notification
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.sender = viewModel.fetchUserForID(userID: notification.senderID)
    }

    var body: some View {
        GeometryReader { geometry in
            rowView
                .dtSwipeAction(rowHeight: 72,
                             labelImage: DtImage.favouriteStarWhite,
                             labelText: "Favourite".localize(),
                             labelColor: .accentsYellow,
                             action: {
                    viewModel.toggleFavourite(id: notification.id)
                })
                .onAppear {
                    viewModel.minYUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                        debouncedMinY = geometry.frame(in: .global).minY
                    }
                }
                .onChange(of: debouncedMinY) { minY in
                    if isViewVisible(minY, geometry.size.height) &&
                        notification.isNew &&
                        !viewModel.viewedNotifications.contains(notification.id) {
                        viewModel.viewedNotifications.insert(notification.id)
                    }
                }
        }
        .frame(height: 72)
    }
}

#Preview {
    NavigationStack {
        NotificationsView(router: Router())
    }
}

private extension NotificationRowView {

    var rowView: some View {
        HStack {
            userPhoto
            textSection
        }
        .overlay(
            Image(DtImage.favouriteStar)
                .foregroundStyle(Color.accentsYellow)
                .opacity(((viewModel.currentUser?.favouriteNotifications.contains(notification.id)) == true) ? 1 : 0)
                .offset(x: 0, y: -16)
            ,
            alignment: .bottomTrailing
        )
    }

    var userPhoto: some View {
        DtUserCircleImage(photoURL: sender?.photoURL ?? "photoPlaceholder",
                          blurRadius: notification.shouldBlur ? 3 : 0)
            .overlay {
                Text(
                    notification.shouldBlur ? "+\(String(viewModel.currentUser?.newMessages ?? 0))" : "")
                .dtTypo(.p1Medium, color: .accentsWhite)
                if notification.isNew {
                    Circle()
                        .frame(width: 12)
                        .foregroundStyle(Color.accentsPink)
                        .overlay {
                            Circle()
                                .stroke(Color.backgroundPrimary, lineWidth: 2)
                        }
                        .offset(x: 20, y: -20)
                }
            }
    }

    var textSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            switch notification.notificationType {
            case .callForAction:
                notificationTitle(title: "Make a first move!".localize())
            case .newMessages:
                notificationTitle(title: "You have unread messages".localize())
            case .visitedProfile:
                let titleName = sender?.name ?? ""
                let titleAge = String(sender?.age ?? 16)
                let title = "\(titleName), \(titleAge)"
                notificationTitle(title: title)
            }
            let secondaryText = switch notification.notificationType {
            case.callForAction: "You've visited \(sender?.name ?? "")'s profile twice, want to start chatting?".localize()
            case.newMessages: "Look at messages from new people, maybe you will like someone".localize()
            case.visitedProfile: "Visited your profile".localize()
            }
            Text(secondaryText)
                .dtTypo(.p3Medium, color: .textSecondary)
                .padding(.trailing, 40)
                .minimumScaleFactor(0.7)
        }
    }

    func isViewVisible(_ minY: CGFloat, _ height: CGFloat) -> Bool {
        let maxY = minY + height
        // TODO: Replace with View extension
        let screenHeight = UIScreen.main.bounds.height
        return minY < screenHeight - 72 && maxY > 72
    }

    @ViewBuilder
    func notificationTitle(title: String) -> some View {
        HStack {
            Text(title)
                .dtTypo(.p2Medium, color: .textPrimary)
            if notification.notificationType == .visitedProfile && sender?.isOnline == true {
                Circle().frame(width: 6).foregroundStyle(.green)
            }
            Spacer()
            Text(DtDateFormatter.basicTime(date: notification.date))
                .dtTypo(.p4Medium, color: .textSecondary)
        }
    }
}
