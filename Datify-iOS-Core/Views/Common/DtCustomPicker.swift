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

    var body: some View {
        ZStack {
            Color.backgroundSecondary
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.backgroundPrimary)
                .padding(.horizontal, 9)
                .frame(height: 32)

            Picker("", selection: $selectedItem) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .tag(item)
                        .dtTypo(.p2Regular, color: .textPrimary)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .contrast(1.4)
            .blendMode(.hardLight)
        }
        .cornerRadius(10)
        .frame(height: 150)
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
