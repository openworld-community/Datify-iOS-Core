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
                    .preference(key: NewSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(NewSizePreferenceKey.self, perform: onChange)
    }

    func sheetFilter<Content: View>(isPresented: Binding<Bool>,
                                    blurRadius: Binding<CGFloat>,
                                    title: String,
                                    content: @escaping () -> Content) -> some View {
        return self.modifier(FilterSheetViewModifier(isPresented: isPresented,
                                             blurRadius: blurRadius,
                                             title: title,
                                             content: content))
    }
}

struct NewSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
