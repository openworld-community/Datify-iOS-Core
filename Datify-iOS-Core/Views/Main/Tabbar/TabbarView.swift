//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct TabbarView<Content: View>: View {
    @StateObject private var viewModel: TabbarViewModel
    @Binding private var selectedTab: TabItem
    let content: (TabItem) -> Content

    init(router: Router<AppRoute>, selectedTab: Binding<TabItem>, content: @escaping (TabItem) -> Content) {
        _viewModel = StateObject(wrappedValue: TabbarViewModel(router: router, selectedTab: selectedTab.wrappedValue))
        _selectedTab = selectedTab
        self.content = content
    }

    var body: some View {
        TrTabbar(tabsData: TabItem.allCases, selectedTab: $selectedTab, model: viewModel) { item in
            createTabView(tab: item)
        }
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating: DatingView(router: Router())
        case .chat: ChatView(router: Router())
        case .menu: MenuView(router: Router())
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static let router: Router<AppRoute> = .init()
    static var selectedTab: TabItem = .chat

    static var previews: some View {
        TabbarView(router: router, selectedTab: .constant(selectedTab)) { tabItem in
            switch tabItem {
            case .dating: AnyView(DatingView(router: Router()))
            case .chat: AnyView(ChatView(router: Router()))
            case .menu: AnyView(MenuView(router: Router()))
            }
        }
    }
}
