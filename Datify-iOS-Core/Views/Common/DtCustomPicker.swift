//
//  DtCustomPicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 15.09.2023.
//

import SwiftUI

struct DtCustomPicker<Item, Content>: View where Item: Hashable, Content: View {
    @Binding var selectedItem: Item
    let items: [Item]
    let content: (Item) -> Content
    let height: CGFloat

    init(selectedItem: Binding<Item>, items: [Item], height: CGFloat = 150, content: @escaping (Item) -> Content) {
        _selectedItem = selectedItem
        self.items = items
        self.content = content
        self.height = height
    }

    var body: some View {
        ZStack {
            Color.backgroundSecondary
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.backgroundPrimary)
                .padding(.horizontal, 9)
                .frame(height: 32)

            Picker("", selection: $selectedItem) {
                ForEach(items, id: \.self) {
                    content($0)
                        .tag($0)
                        .dtTypo(.p2Regular, color: .textPrimary)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .contrast(1.4)
            .blendMode(.hardLight)
        }
        .cornerRadius(10)
        .frame(height: height)
    }
}

struct DtCustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DtCustomPicker(selectedItem: .constant(1), items: Array(1...5)) { item in
                Text("\(item)")
            }
        }
    }
}
