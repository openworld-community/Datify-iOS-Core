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
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
