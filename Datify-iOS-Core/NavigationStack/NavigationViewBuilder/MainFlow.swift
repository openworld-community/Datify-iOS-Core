//
//  MainFlow.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

protocol MainFlow {
    associatedtype Dating: View
    associatedtype Chat: View
    associatedtype Menu: View
    associatedtype Notifications: View

    func createDatingView() -> Dating
    func createChatView() -> Chat
    func createMenuView() -> Menu
    func createNotificationsView() -> Notifications
}

extension NavigationViewBuilder: MainFlow {
    func createDatingView() -> some View {
        DatingView(router: router)
    }
    func createNotificationsView() -> some View {
        NotificationsView(router: router)
    }
    func createChatView() -> some View {
        ChatView(router: router)
    }
    func createMenuView() -> some View {
        MenuView(router: router)
    }
}
