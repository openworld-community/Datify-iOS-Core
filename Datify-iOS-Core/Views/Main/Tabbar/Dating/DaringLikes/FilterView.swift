//
//  FilterView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 09.12.2023.
//

import SwiftUI

protocol FilterProtocol: CaseIterable, Equatable, Hashable {
    var title: String {get}
}

struct FilterView<T: FilterProtocol>: View {
    @Binding var sortOption: T
    private var title: String?

    init(sortOption: Binding<T>, titleOne: String? = nil) {
        _sortOption = sortOption
        self.title = titleOne
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .dtTypo(.h3Medium, color: .textPrimary)
            }
            ForEach(Array(T.allCases), id: \.self) { option in
                DtSelectorButton(isSelected: sortOption == option, title: option.title) {
                    sortOption = option
                }
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    FilterView(sortOption: .constant(LikeSortOption.allTime), titleOne: "Sort")
}
