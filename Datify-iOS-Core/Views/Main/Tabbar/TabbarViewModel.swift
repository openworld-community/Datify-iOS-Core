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

    func showView(selectedTab: TabItem) {
        switch selectedTab {
        case .dating:
            router.push(.dating)
                print("Navigating to DatingView")

        case .chat:
            router.push(.chat)
                print("Navigating to ChatView")

            case .menu:
            router.push(.menu)
                print("Navigating to MenuView")

        }
    }
}
