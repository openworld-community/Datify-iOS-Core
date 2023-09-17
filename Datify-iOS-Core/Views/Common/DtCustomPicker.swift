//
//  DtCustomPicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 15.09.2023.
//

import SwiftUI

struct DtCustomPicker<T>: View where T: Hashable, T: CustomStringConvertible {
    @Binding var selectedItem: T
    private var items: [T]
    private var pickerText: (T) -> Text

    init(
        selectedItem: Binding<T>,
        items: ClosedRange<T>,
        pickerText: @escaping (T) -> Text
    ) where T == Int {
        self._selectedItem = selectedItem
        self.items = Array(items)
        self.pickerText = pickerText
    }

    var body: some View {
        Picker("", selection: $selectedItem) {
            ForEach(items, id: \.self) { item in
                pickerText(item)
                    .dtTypo(.p2Regular, color: .textPrimary)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(height: 150)
        .background(
            ZStack {
                Color.backgroundSecondary
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.backgroundPrimary)
                    .padding(.horizontal, 9)
                    .frame(height: 32)
            }
        )
        .cornerRadius(10)
    }
}

struct DtCustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        DtCustomPicker(selectedItem: .constant(1), items: 1...50) { int in
            Text("\(int)")
        }
    }
}
