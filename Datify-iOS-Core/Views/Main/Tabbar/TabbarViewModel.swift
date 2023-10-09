//
//  TabbarViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

final class TabbarViewModel: ObservableObject {
    @Published var selectedTab: TabItem

    init(selectedTab: TabItem) {
        self.selectedTab = selectedTab
    }
}
