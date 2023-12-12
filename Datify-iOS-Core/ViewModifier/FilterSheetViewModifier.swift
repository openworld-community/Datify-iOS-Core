//
//  FilterSheetViewModifier.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 08.12.2023.
//

import SwiftUI
import UIKit

struct FilterSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct FilterSheetViewModifier<T: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @Binding private var blurRadius: CGFloat
    @State private var sizes: CGSize = .zero
    private var title: String
    private let viewBilder: () -> T

    init(isPresented: Binding<Bool>, blurRadius: Binding<CGFloat>, title: String, content: @escaping () -> T) {
        _isPresented = isPresented
        _blurRadius = blurRadius
        self.title = title
        self.viewBilder = content
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: blurRadius)
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    GeometryReader { geometry in
                        ZStack {
                            Color.backgroundPrimary.ignoresSafeArea()
                            viewBilder()
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
                                        Text(title)
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
 }

private extension FilterSheetViewModifier {
    func interpolatedValue(for height: CGFloat) -> CGFloat {
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
