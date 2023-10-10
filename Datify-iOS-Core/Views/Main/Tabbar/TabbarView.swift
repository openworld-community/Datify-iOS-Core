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

      init(router: Router<AppRoute>, selectedTab: TabItem = .dating) {
          _viewModel = StateObject(wrappedValue: TabbarViewModel(router: router, selectedTab: selectedTab))
          _selectedTab = State(initialValue: selectedTab)
      }

    var body: some View {
        TrTabbar(tabsData: TabItem.allCases, selectedTab: $selectedTab, model: viewModel) { item in
            createTabView(tab: item)
        }
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating:
            DatingView(router: viewModel.router)
        case .chat:
            ChatView(router: viewModel.router)
        case .menu:
            MenuView(router: viewModel.router)
        }
    }
}
