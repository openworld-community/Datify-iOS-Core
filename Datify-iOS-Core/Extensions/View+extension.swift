//
//  View+extension.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.09.2023.
//

import SwiftUI

extension View {
    func hideKeyboardTapOutside() -> some View {
        onTapGesture { UIApplication.shared.dismissKeyboard() }
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FilterSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(FilterSizePreferenceKey.self, perform: onChange)
    }
}

struct NewSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
