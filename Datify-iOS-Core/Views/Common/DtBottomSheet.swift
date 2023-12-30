//
//  DtBottomSheet.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 29.12.2023.
//

import SwiftUI

struct DtBottomSheet<LabelContent: View>: ViewModifier {
    @State private var dragAmount: CGFloat = .zero
    @State private var currentHeight: CGFloat = .zero
    
    @Binding var isPresented: Bool
    let interactiveDismissable: Bool
    let presentationDetents: Set<CGFloat>
    let label: () -> LabelContent

    // swiftlint:disable function_body_length
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 17.0, *) {
                content
                    .onChange(of: presentationDetents, {
                        if let minHeight = presentationDetents.min() {
                            currentHeight = minHeight
                        }
                    })
                    .onTapGesture {
                        if interactiveDismissable {
                            isPresented = false
                        }
                    }
            } else {
                content
                    .onChange(of: presentationDetents, perform: { value in
                        if let minHeight = value.min() {
                            print("minHeight = \(minHeight)")
                            currentHeight = minHeight
                        }
                    })
                    .onTapGesture {
                        if interactiveDismissable {
                            isPresented = false
                        }
                    }
            }

            if isPresented {
                ZStack {
                    Color.backgroundPrimary
                        .clipShape(
                            .rect(
                                topLeadingRadius: AppConstants.Visual.cornerRadius,
                                topTrailingRadius: AppConstants.Visual.cornerRadius
                            )
                        )
                        .padding(.bottom, -UIScreen.main.bounds.height)

                    label()
                        .readSize { labelSize in
                            if let minHeight = presentationDetents.min() {
                                currentHeight = minHeight
                            }
                            if currentHeight <= 0 {
                                currentHeight = labelSize.height
                            }
                        }

                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundStyle(Color.labelsTertiary)
                        .frame(width: 36, height: 5)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 5)
                }
                .frame(
                    width: .infinity,
                    height: currentHeight,
                    alignment: .top
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .offset(y: dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged {
                            if presentationDetents.count <= 1 {
                                if interactiveDismissable {
                                    dragAmount = max($0.translation.height, -5)
                                } else {
                                    dragAmount = min(max($0.translation.height, -5), 5)
                                }
                            } else {
                                if currentHeight == presentationDetents.min() {
                                    dragAmount = min(max($0.translation.height, currentHeight - (presentationDetents.max() ?? 0) - 5), 5)
                                } else if currentHeight == presentationDetents.max() {
                                    dragAmount = max(min($0.translation.height, currentHeight - (presentationDetents.min() ?? 0) + 5), -5)
                                } else {
                                    dragAmount = $0.translation.height
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if presentationDetents.count <= 1 {
                                    if interactiveDismissable {
                                        if value.translation.height > currentHeight / 2 {
                                            isPresented = false
                                            dragAmount = .zero
                                        } else {
                                            dragAmount = .zero
                                        }
                                    } else {
                                        dragAmount = .zero
                                    }
                                } else {
                                    let presentationDetentsSorted = presentationDetents.sorted(by: { $0 < $1 })

                                    if currentHeight == presentationDetentsSorted.first {
                                        let difference = presentationDetentsSorted[1] - currentHeight

                                        if value.translation.height < -(difference / 2) {
                                            currentHeight = presentationDetentsSorted[1]
                                            dragAmount = .zero
                                        } else {
                                            dragAmount = .zero
                                        }
                                    } else if currentHeight == presentationDetentsSorted.last {
                                        let difference = currentHeight - presentationDetentsSorted[presentationDetentsSorted.count - 2]

                                        if value.translation.height > difference / 2 {
                                            currentHeight = presentationDetentsSorted[presentationDetentsSorted.count - 2]
                                            dragAmount = .zero
                                        } else {
                                            dragAmount = .zero
                                        }
                                    }
                                }
                            }
                        }
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.easeOut(duration: 0.3), value: isPresented)
    }
}

extension View {
    func dtBottomSheet<LabelContent: View>(
        isPresented: Binding<Bool>,
        interactiveDismissable: Bool = false,
        presentationDetents: Set<CGFloat> = .init(),
        label: @escaping () -> LabelContent
    ) -> some View {
        modifier(DtBottomSheet(
            isPresented: isPresented,
            interactiveDismissable: interactiveDismissable,
            presentationDetents: presentationDetents,
            label: label
        ))
    }
}
