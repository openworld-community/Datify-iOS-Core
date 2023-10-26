//
//  DtSegmentedPicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 13.10.2023.
//

import SwiftUI

struct DtSegmentedPicker<Item, Content>: View where Item: Hashable, Content: View {
    @Binding private var selectedItem: Item
    private let items: [Item]
    private let content: (Item) -> Content

    init(selectedItem: Binding<Item>, items: [Item], content: @escaping (Item) -> Content) {
        let selectedSegmentTintColor = UIColor(.textPrimary)
        let selectedTitleColor = UIColor(.textInverted)
        UISegmentedControl.appearance()
            .setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
        UISegmentedControl.appearance()
            .selectedSegmentTintColor = selectedSegmentTintColor
        UISegmentedControl.appearance()
            .setTitleTextAttributes([.foregroundColor: selectedTitleColor], for: .selected)

        _selectedItem = selectedItem
        self.items = items
        self.content = content
    }

    var body: some View {
        Picker("", selection: $selectedItem) {
            ForEach(items, id: \.self) {
                content($0)
                    .tag($0)
                    .dtTypo(.p2Regular, color: .textPrimary)
            }
        }
        .foregroundStyle(.black)
        .pickerStyle(.segmented)
    }
}

struct DtSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        DtSegmentedPicker(selectedItem: .constant(2),
                          items: Array(1...3)) { item in
            Text("\(item)")
        }
    }
}
