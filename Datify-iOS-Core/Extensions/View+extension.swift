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

// MARK: SwipeActionModifier
private struct SwipeActionModifier: ViewModifier {
    @State private var xOffset: CGFloat = 0
    @State private var initialXOffset: CGFloat?
    private let actionWidth: CGFloat = 96
    private let rowHeight: CGFloat
    private let action: () -> Void
    private let labelImage: String
    private let labelText: String
    private let labelColor: Color

    init(rowHeight: CGFloat, labelImage: String, labelText: String, labelColor: Color, action: @escaping () -> Void) {
        self.action = action
        self.labelImage = labelImage
        self.labelText = labelText
        self.labelColor = labelColor
        self.rowHeight = rowHeight
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            swipeButton
            content
                .frame(height: rowHeight)
                .padding(.horizontal, 12)
                .background(
                    ZStack {
                        let opacity1 = 1 + (xOffset / actionWidth)
                        Color.backgroundSpecial
                        Color.backgroundPrimary.opacity(opacity1)
                    }
                )
                .offset(x: xOffset)
                .gesture(swipeActionGesture())
        }
    }

    var swipeButton: some View {
        Button {
            action()
            self.resetSwipe()
        } label: {
            VStack {
                Image(labelImage)
                Text(labelText)
                    .dtTypo(.p4Medium, color: .white)
            }
            .frame(width: 120, height: rowHeight)
            .background(labelColor)
        }
        .frame(width: actionWidth)
    }

    func swipeActionGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let deltaX = value.translation.width
                if initialXOffset == nil {
                    initialXOffset = xOffset
                }
                guard let initialXOffset = initialXOffset else { return }
                let newOffset = max(-105, min(0, initialXOffset + deltaX))
                if deltaX <= -actionWidth/4 || initialXOffset == -actionWidth {
                    withAnimation {
                        xOffset = newOffset
                    }
                }
            }
            .onEnded { value in
                let deltaX = value.translation.width
                if deltaX < 0 && ((initialXOffset ?? 0) + deltaX) <= -actionWidth/2 {
                    withAnimation {
                        xOffset = -actionWidth
                    }
                } else { resetSwipe() }
                initialXOffset = nil
            }
    }

    func resetSwipe() {
        withAnimation {
            xOffset = 0
        }
    }
}

extension View {
    func dtSwipeAction(
        rowHeight: CGFloat,
        labelImage: String,
        labelText: String,
        labelColor: Color,
        action: @escaping () -> Void
        ) -> some View {
            self.modifier(SwipeActionModifier(rowHeight: rowHeight,
                                              labelImage: labelImage,
                                              labelText: labelText,
                                              labelColor: labelColor,
                                              action: action)
            )
        }
}
