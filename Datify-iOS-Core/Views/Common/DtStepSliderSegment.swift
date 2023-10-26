//
//  DtCustomSlider.swift
//  Datify-iOS-Core
//
//  Created by Илья on 17.10.2023.
//

import SwiftUI
struct DtStepSliderSegment<Item>: View where Item: Hashable {
    @Binding var selectedItem: Item
    @State private var isInitialized: Bool = false
    private let circleWidth: CGFloat = 32
    private let items: [Item]
    private let labels: [String]
    private let numberOfSteps: Int

    init(selectedItem: Binding<Item>,
         isInitialized: Bool = false,
         items: [Item],
         labels: [String]) {
        _selectedItem = selectedItem
        self.items = items
        self.numberOfSteps = items.count - 1
        self.labels = labels
        self.isInitialized = isInitialized
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .foregroundStyle(Color.backgroundSecondary)
                .frame(height: 84)
                .task {
                    try? await Task.sleep(nanoseconds: UInt64(30))
                    isInitialized = true
                }
            if isInitialized {
                VStack {
                    labelStack
                        .frame(height: 15)
                    DtStepSlider(circleWidth: circleWidth,
                                 items: items,
                                 selectedItem: $selectedItem)
                        .frame(height: 30)
                }
                .padding(.horizontal)
            }
        }
    }
}

private extension DtStepSliderSegment {
    var labelStack: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                let labelStep = geometry.size.width/CGFloat(labels.count-1)
                HStack {
                    Text(labels.first ?? "1")
                    Spacer()
                    Text(labels.last ?? "0")
                }
                ForEach(Array(labels.enumerated()), id: \.0) { index, label in
                    if !(index == 0 || index == labels.count-1) {
                        let labelSize = label.getSize(fontSize: 14, fontWeight: .medium)/2
                        let labelOffset = CGFloat(index) * labelStep
                        Text(label)
                            .offset(x: labelOffset - labelSize)
                    }
                }
            }
            .dtTypo(.p3Medium, color: .textPrimary)
        }
    }
}

#Preview {

    VStack(spacing: 40) {
        DtStepSliderSegment<Distances>(selectedItem: .constant(.optionTwo),
                                       items: Distances.allCases,
                                       labels: Distances.allLabels)
        DtStepSliderSegment(selectedItem: .constant(7),
                            items: Array(1...9),
                            labels: ["One", "Three", "Five", "Seven", "Nine"])
        DtStepSliderSegment(selectedItem: .constant(2),
                            items: Array(1...3),
                            labels: ["One", "Two", "Three"])

        // Can be used in Quiz
        VStack(alignment: .leading) {
            Text("On a scale from 1 to 10, how much do you like ...?")
                .dtTypo(.p3Medium, color: .primary)

            let localItems = Array(1...10)
            let localLabels = localItems.map { String($0) }
            DtStepSliderSegment(selectedItem: .constant(2),
                                items: localItems,
                                labels: localLabels)
        }

    }
    .padding()
}
