//
//  TabbarViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI
import Combine

final class TabbarViewModel: ObservableObject {
    @Published var selectedTab: TabItem

    unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>, selectedTab: TabItem) {
        self.router = router
        self.selectedTab = selectedTab
    }
}
