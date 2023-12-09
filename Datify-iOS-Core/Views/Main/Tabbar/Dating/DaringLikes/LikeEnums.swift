//
//  LikeEnums.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 09.12.2023.
//

import SwiftUI

protocol FilterProtocol: CaseIterable, Equatable, Hashable {
    var title: String {get}
}

struct FilterSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

enum LikeSortOption: String, CaseIterable, Equatable, FilterProtocol {
    case lastDay, lastWeek, lastMonth, allTime
    var title: String {
        return self.rawValue
            .capitalized
            .localize()
    }
}

enum LikeTage: CaseIterable {
    case receivedLikes, mutualLikes, myLikes
    var title: String {
        switch self {
        case .mutualLikes: return "mutual".localize()
        case .myLikes: return "my".localize()
        case .receivedLikes: return "received".localize()
        }
    }
}
