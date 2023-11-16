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
    private let rowHeight: CGFloat = 72

    @State private var debouncedMinY: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var initialXOffset: CGFloat?
    private let actionWidth: CGFloat = 96

    init(notification: NotificationModel, viewModel: NotificationsViewModel) {
        self.notification = notification
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.sender = viewModel.fetchUserForID(for: notification.senderID)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                favouriteButton
                rowView
            }
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
        .frame(height: rowHeight)
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
        .frame(height: rowHeight)
        .padding(.horizontal, 12)
        .background(
            ZStack {
                let opacity1 = 1 + (xOffset / actionWidth)
                Color.backgroundSpecial
                Color.backgroundPrimary.opacity(opacity1)
            }
        )
        .overlay(
            Image(DtImage.favouriteStar)
                .foregroundStyle(Color.accentsYellow)
                .opacity(((viewModel.user?.favouriteNotifications.contains(notification.id)) == true) ? 1 : 0)
                .offset(x: -20, y: -16)
            ,
            alignment: .bottomTrailing
        )
        .offset(x: xOffset)
        .gesture(swipeActionGesture())
    }

    var favouriteButton: some View {
        Button {
            viewModel.toggleFavourite(id: notification.id)
            self.resetSwipe()
        } label: {
            VStack {
                Image(DtImage.favouriteStarWhite)
                Text("Favourite")
                    .dtTypo(.p4Medium, color: .white)
            }
            .frame(width: 120, height: rowHeight)
            .background(Color.accentsYellow)
        }
        .frame(width: actionWidth)
    }

    var userPhoto: some View {
        Image(sender?.photoURL ?? "photoPlaceholder")
            .resizableFill()
            .blur(radius: notification.shouldBlur ? 3 : 0)
            .clipShape(.circle)
            .frame(width: 56, height: 56)
            .overlay {
                Text(
                    notification.shouldBlur ? "+\(String(viewModel.user?.newMessages ?? 0))" : "")
                .dtTypo(.p1Medium, color: .accentsWhite)
                if notification.isNew {
                    Circle()
                        .frame(width: 12)
                        .foregroundStyle(Color.red)
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
            case.callForAction: "You've visited \(sender?.name ?? "")'s profile twice, want to start chatting?"
            case.newMessages: "Look at messages from new people, maybe you will like someone"
            case.visitedProfile: "Visited your profile"
            }
            Text(secondaryText)
                .dtTypo(.p3Medium, color: .textSecondary)
                .padding(.trailing, 40)
                .minimumScaleFactor(0.7)
        }
    }

    func swipeActionGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let deltaX = value.translation.width
                if initialXOffset == nil {
                    initialXOffset = xOffset
                }
                guard let initialXOffset = initialXOffset else { return }
                let newOffset = max(-105, min(0, initialXOffset + deltaX))
                if deltaX <= -actionWidth/4 || initialXOffset == -actionWidth {
                    withAnimation {
                        xOffset = newOffset
                    }
                }
            }
            .onEnded { value in
                let deltaX = value.translation.width
                if deltaX < 0 && ((initialXOffset ?? 0) + deltaX) <= -actionWidth/2 {
                    withAnimation {
                        xOffset = -actionWidth
                    }
                } else { resetSwipe() }
                initialXOffset = nil
            }
    }

    func isViewVisible(_ minY: CGFloat, _ height: CGFloat) -> Bool {
        let maxY = minY + height
        // TODO: Replace with View extension
        let screenHeight = UIScreen.main.bounds.height
        return minY < screenHeight - rowHeight && maxY > rowHeight
    }

    func resetSwipe() {
        withAnimation {
            xOffset = 0
        }
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
            Text(notification.dateToTimeString())
                .dtTypo(.p4Medium, color: .textSecondary)
        }
    }
}
