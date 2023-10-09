//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct TabbarView: View {
    unowned let viewBuilder: NavigationViewBuilder
    @StateObject private var model: TabbarViewModel

    init(viewBuilder: NavigationViewBuilder, model: @autoclosure @escaping () -> TabbarViewModel) {
        self.viewBuilder = viewBuilder
        _model = StateObject(wrappedValue: model())
    }

    var body: some View {
        TrTabbar(tabsData: TabItem.allCases, selectedTab: $model.selectedTab, model: model) { item in
            createTabView(tab: item)
//            NavigationView {
//            }
        }
//        .id(model.refreshID)
//        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating: viewBuilder.createLoginView()
        case .chat: viewBuilder.createTempView()
        case .menu: viewBuilder.createRegSexView()
        }
    }
}
