//
//  FilterView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 08.12.2023.
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

struct FilterSheetView<Content: View>: View {
    @Binding private var blurRadius: CGFloat
    @State private var sizes: CGSize = .zero
    private let content: () -> Content

    init(blurRadius: Binding<CGFloat>, content: @escaping () -> Content) {
        _blurRadius = blurRadius
        self.content = content
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.backgroundPrimary.ignoresSafeArea()
                    content()
                        .background(
                            GeometryReader {  geometry in
                                Color.clear
                                    .preference(key: NewSizePreferenceKey.self, value: geometry.size)
                            }
                        )
                        .onPreferenceChange(NewSizePreferenceKey.self) { newSizes in
                            sizes = newSizes
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                DtXMarkButton()
                                .padding(.top)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Filters")
                                .dtTypo(.h3Medium, color: .textPrimary)
                                .padding(.top)
                        }
                    }
                }
                .onChange(of: geometry.frame(in: .global).minY) { minY in
                    withAnimation {
                        blurRadius = interpolatedValue(for: minY)
                    }
                }
            }
        }
        .presentationDetents([.height(sizes.height + 100)])
        .presentationDragIndicator(.visible)
    }
 }

private extension FilterSheetView {
    func interpolatedValue(for height: CGFloat) -> CGFloat {
        // TODO: Replace with View extension
        let screenHeight = UIScreen.main.bounds.height
        let startHeight = screenHeight
        let endHeight = screenHeight - 350
        let startValue: CGFloat = 0.0
        let endValue: CGFloat = 10.0

        if height >= startHeight || height <= 100 {
            return startValue
        } else if height <= endHeight {
            return endValue
        }
        let slope = (endValue - startValue) / (endHeight - startHeight)
        return startValue + slope * (height - startHeight)
    }
}

 #Preview {
     FilterSheetView(blurRadius: .constant(0)) {
         FilterView(sortOption: .constant(LikeSortOption.allTime), titleOne: "Sort")
     }
 }
