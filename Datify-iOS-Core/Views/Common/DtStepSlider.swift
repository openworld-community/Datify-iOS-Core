//
//  DtStepSlider.swift
//  Datify-iOS-Core
//
//  Created by Илья on 24.10.2023.
//

import SwiftUI

struct DtStepSlider<Item>: View where Item: Hashable {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedItem: Item
    @State private var offset: CGFloat = 0
    private let numberOfSteps: Int
    private let circleWidth: CGFloat
    private let items: [Item]

    init(circleWidth: CGFloat, items: [Item], selectedItem: Binding<Item>) {
        self.circleWidth = circleWidth
        self.items = items
        self.numberOfSteps = items.count-1
        _selectedItem = selectedItem
    }

    var body: some View {
        GeometryReader { geometry in
            let step = geometry.size.width/CGFloat(numberOfSteps)
            ZStack(alignment: .leading) {
                Color.backgroundStroke
                    .mask(sliderLayout)

                getColorSchemeMask()

                Circle()
                    .frame(width: circleWidth, height: circleWidth)
                    .foregroundStyle(Color.white)
                    .overlay {
                        Image(DtImage.strokes)
                    }
                    .shadow(radius: 6, y: 5)
                    .offset(x: offset)
                    .gesture(DragGesture().onChanged {
                        sliderAction(value: $0, step: step, width: geometry.size.width)
                    })
            }
            .task {
                if let index = items.firstIndex(of: selectedItem) {
                    switch index {
                    case 0:
                        offset = 10 - circleWidth/2
                    case
                    numberOfSteps: offset = CGFloat(index) * step - circleWidth / 2 - 10
                    default:
                        offset = CGFloat(index) * step - circleWidth/2
                    }

                }
            }
        }
        .frame(height: 30)
    }
}

private extension DtStepSlider {
    private func getColorSchemeMask() -> some View {
        let gradient = colorScheme == .light ?
        Color.DtGradient.brandLight :
        Color.DtGradient.brandDark

        return gradient
            .mask(sliderLayout)
            .mask {
                HStack {
                    Rectangle().frame(width: offset*2+32)
                        .position(x: 0, y: 5)
                }
            }
    }

    private var sliderLayout: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 2)
            HStack {
                ForEach(0...numberOfSteps, id: \.self) { index in
                    Capsule()
                        .frame(width: 2, height: 10)
                    if index != numberOfSteps {
                        Spacer()
                    }
                }
            }
        }
    }

    private func sliderAction(value: DragGesture.Value, step: CGFloat, width: CGFloat) {
        for (index, item) in items.enumerated() {
            let startRange: CGFloat
            let endRange: CGFloat

            if index == 0 {
                startRange = -10
                endRange = 10
            } else {
                startRange = CGFloat(index) * step - 10
                endRange = CGFloat(index) * step + 10
            }
            let range: ClosedRange<CGFloat> = startRange...endRange
            if range.contains(value.location.x) {
                selectedItem = item
                switch index {
                case 0:
                    offset = 10 - circleWidth / 2
                case numberOfSteps:
                    offset = width - circleWidth / 2 - 10
                default:
                    offset = CGFloat(index) * step - circleWidth / 2
                }
                break
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        DtStepSlider(circleWidth: 22,
                     items: Distances.allCases,
                     selectedItem: .constant(.optionTwo))
        .padding(.horizontal, 70)
        DtStepSlider(circleWidth: 25,
                     items: Distances.allCases,
                     selectedItem: .constant(.optionFour))
        .padding(.horizontal, 30)
        DtStepSlider(circleWidth: 32,
                     items: [1, 2, 3, 4, 5, 6, 7],
                     selectedItem: .constant(4))
    }
    .padding(.horizontal)
}
