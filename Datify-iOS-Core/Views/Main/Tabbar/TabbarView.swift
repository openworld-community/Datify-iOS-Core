//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct TabbarView: View {
    @StateObject private var viewModel: TabbarViewModel
    @State private var selectedTab: TabItem
    unowned let viewBuilder: NavigationViewBuilder

    init(viewBuilder: NavigationViewBuilder, selectedTab: TabItem = .dating) {
        self.viewBuilder = viewBuilder
        _viewModel = StateObject(wrappedValue: TabbarViewModel(selectedTab: selectedTab))
        _selectedTab = State(initialValue: selectedTab)
    }

    var body: some View {
        DtTabbar(tabsData: TabItem.allCases, selectedTab: $selectedTab, viewModel: viewModel) { item in
            createTabView(tab: item)
        }
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating: viewBuilder.createDatingView()
        case .chat: viewBuilder.createChatView()
        case .menu: viewBuilder.createMenuView()
        }
    }
}