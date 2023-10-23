//
//  TabItem.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import Foundation
import shared

enum TabItem: String, CaseIterable {
    case dating
    case chat
    case menu

    func title() -> String {
        switch self {
        case .dating:
            return "Dating".localize()
        case .chat:
            return "Chat".localize()
        case .menu:
            return "Menu".localize()
        }
    }

    func image(isSelected: Bool) -> String {
        switch self {
        case .dating:
            return DtImage.tabbarDating
        case .chat:
            return DtImage.tabbarChat
        case .menu:
            return DtImage.tabbarMenu
        }
    }
}

extension TabItem: Identifiable {
    var id: String { rawValue }

    init(id: TabItem.ID) {
        self = TabItem(rawValue: id) ?? .dating
    }
}
