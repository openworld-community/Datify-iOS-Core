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
    associatedtype Profile: View

    func createDatingView(isSheetPresented: Binding<Bool>) -> Dating
    func createChatView() -> Chat
    func createMenuView() -> Menu
    func createNotificationsView() -> Notifications
    func createProfileView() -> Profile
}

extension NavigationViewBuilder: MainFlow {
    func createDatingView(isSheetPresented: Binding<Bool>) -> some View {
        DatingView(
            router: router,
            isSheetPresented: isSheetPresented
        )
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
    func createProfileView() -> some View {
        ProfileView(router: router)
    }
}
