//
//  CustomPicker.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.09.2023.
//

import SwiftUI

struct CustomPicker<T: Equatable>: View {

    private let options: [T]
    @Binding var selection: T
    @State private var drag: Double = 0
    private let cellAngles = 20.0
    private let presentation: (T) -> String

    init(_ options: [T], _ selection: Binding<T>, _ presentation: @escaping (T) -> String = {"\($0)"}) {
        self.options = options
        self._selection = selection
        self.presentation = presentation
    }

    var body: some View {
        let selectedIndex = getSelectedIndex()
        HStack {
            ZStack {
                ForEach(0..<options.count, id: \.self) { index in
                    let item: T = options[index]
                    CustomPickerCell(title: presentation(item),
                                     angle: Double(index - selectedIndex) * cellAngles + drag)
                }
            }
            .frame(width: 100, height: 200)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        drag = gesture.translation.height
                    }
                    .onEnded { _ in
                        withAnimation(.easeIn) {
                            var newIndex = selectedIndex - Int(round(drag / cellAngles))
                            if newIndex < 0 {
                                newIndex = 0
                            }
                            if newIndex >= options.count - 1 {
                                newIndex = options.count - 1
                            }
                            selection = options[newIndex]
                            drag = 0
                        }

                    }
            )
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .frame(height: 120)
                    .foregroundColor(.backgroundSecondary)
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 86, height: 24)
                    .foregroundColor(.backgroundPrimary)
            }
        )
    }

    private func getSelectedIndex() -> Int {
        return options.firstIndex(of: selection) ?? 0
    }

}

private struct CustomPickerCell: View {

    let title: String
    let angle: Double

    var body: some View {
        if abs(angle) > 90 {
            EmptyView()
        } else {
            let sinValue = sin(rad(angle))
            let cosValue = cos(rad(angle))
            Text(title)
                .foregroundColor(.primary)
                .scaleEffect(y: cosValue)
                .offset(y: sinValue * 66)
                .opacity(abs(angle) < 5 ? 1.0 : cosValue/2)

        }
    }

    func rad(_ number: Double) -> Double {
        return number * .pi / 180
    }

}
