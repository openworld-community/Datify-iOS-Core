//
//  TabbarViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI
import Combine

enum UnreadCountState {
    case noAlarms
    case count(Int)
}

final class TabbarViewModel: ObservableObject {

    @Published var selectedTab: TabItem
    private var subscriptions: Set<AnyCancellable> = []
    @Published var alarmsUnreadCountState: UnreadCountState = .noAlarms

    @Published var isSheetPresented: Bool = false

    init(selectedTab: TabItem, initialUnreadCount: Int? = nil) {
        self.selectedTab = selectedTab
        if let initialUnreadCount = initialUnreadCount {
            self.alarmsUnreadCountState = .count(initialUnreadCount)
        }
    }

    func updateAlarmsUnreadCount(_ newCount: Int) {
        self.alarmsUnreadCountState = .count(newCount)
    }
}
