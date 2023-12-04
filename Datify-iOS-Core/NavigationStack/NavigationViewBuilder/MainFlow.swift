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

    func createDatingView(
        dtConfDialogIsPresented: Binding<Bool>,
        complainSheetIsPresented: Binding<Bool>) -> Dating
    func createChatView() -> Chat
    func createMenuView() -> Menu
}

extension NavigationViewBuilder: MainFlow {
    func createDatingView(
        dtConfDialogIsPresented: Binding<Bool>,
        complainSheetIsPresented: Binding<Bool>
    ) -> some View {
        DatingView(
            router: router,
            dtConfDialogIsPresented: dtConfDialogIsPresented,
            complainSheetIsPresented: complainSheetIsPresented
        )
    }
    func createChatView() -> some View {
        ChatView(router: router)
    }
    func createMenuView() -> some View {
        MenuView(router: router)
    }
}
