//
//  DtBottomSheet.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 31.12.2023.
//

import SwiftUI

struct DtBottomSheet<LabelContent: View>: ViewModifier {
    @State private var translationY: CGFloat = .zero
    @State private var offsetY: CGFloat = 0
    @Binding var isPresented: Bool
    //    let screenHeight: CGFloat
    let isBackground: Bool
    let interactiveDismissable: Bool
    let presentationDetents: Set<CGFloat>
    let label: () -> LabelContent

    func body(content: Content) -> some View {
        let screenHeight: CGFloat = UIScreen.main.bounds.height

        ZStack(alignment: .bottom) {
            content
                .simultaneousGesture(TapGesture()
                    .onEnded {
                        onTapped(screenHeight: screenHeight)
                    }
                )
                .onChange(of: presentationDetents) { _, newValue in
                    onChanged(value: newValue, screenHeight: screenHeight)
                }

            if isPresented {
                ZStack {
                    label()
                        .readSize { labelSize in
                            if presentationDetents.isEmpty {
                                offsetY = screenHeight - labelSize.height
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)

                    if !presentationDetents.isEmpty {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(Color.labelsTertiary)
                            .frame(width: 36, height: 5)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top, 5)
                    }
                }
                .background(
                    Color.backgroundPrimary
                        .mask(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius, style: .continuous))
                        .padding(.bottom, -screenHeight)
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .offset(y: translationY + offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            translationY = value.translation.height
                        }
                        .onEnded { _ in
                            onEndedDragGesture(screenHeight: screenHeight)
                        }
                )
            }
        }
        .ignoresSafeArea()
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9), value: isPresented)
        .blur(radius: isBackground ? 10 : 0)
    }

    private func onTapped(screenHeight: CGFloat) {
        if interactiveDismissable {
            isPresented = false
        } else if !presentationDetents.isEmpty,
                  let minHeight = presentationDetents.min() {
            withAnimation {
                offsetY = screenHeight - minHeight
            }
        }
    }

    private func onChanged(value: Set<CGFloat>, screenHeight: CGFloat) {
        if let minHeight = value.min() {
            offsetY = screenHeight - minHeight
        }
    }

    private func onEndedDragGesture(screenHeight: CGFloat) {
        withAnimation(
            .interactiveSpring(response: 0.5, dampingFraction: 0.9)
        ) {
            let snap = translationY + offsetY

            if !presentationDetents.isEmpty {
                let offsets = presentationDetents.map {screenHeight - $0}

                if snap > (offsets.max() ?? 0) + (screenHeight - (offsets.max() ?? 0)) / 2 && interactiveDismissable {
                    isPresented = false
                } else {
                    offsetY = (offsets.min(by: {
                        abs($0 - snap) < abs($1 - snap)
                    }) ?? 0)
                }
            } else {
                if interactiveDismissable {
                    let maxOffset = offsetY + (screenHeight - offsetY) / 2

                    if snap > maxOffset {
                        isPresented = false
                    }
                }
            }

            translationY = .zero
        }
    }
}

extension View {
    func dtBottomSheet<LabelContent: View>(
        isPresented: Binding<Bool>,
        isBackground: Bool = false,
        interactiveDismissable: Bool = false,
        presentationDetents: Set<CGFloat> = .init(),
        label: @escaping () -> LabelContent
    ) -> some View {
        modifier(
            DtBottomSheet(
                isPresented: isPresented,
                isBackground: isBackground,
                interactiveDismissable: interactiveDismissable,
                presentationDetents: presentationDetents,
                label: label
            )
        )
    }
}
