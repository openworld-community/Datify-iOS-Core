//
//  DtSheet.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 02.12.2023.
//

import SwiftUI

struct DtSheet<LabelContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let label: () -> LabelContent

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .blur(radius: isPresented ? 10 : 0)
                .scaleEffect(isPresented ? 1.2 : 1)
                .disabled(isPresented)

            if isPresented {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0),
                        Gradient.Stop(color: .black.opacity(1), location: 1)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

                GroupBox {
                    label()
                        .frame(maxWidth: .infinity)
                }
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .groupBoxStyle(DtGroupBoxStyle())
                .padding(.horizontal, 8)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .animation(.easeOut(duration: 0.3), value: isPresented)
    }
}

extension View {
    func dtSheet<LabelContent: View>(
        isPresented: Binding<Bool>,
        label: @escaping () -> LabelContent
    ) -> some View {
        modifier(DtSheet<LabelContent>(
            isPresented: isPresented,
            label: label
        ))
    }
}
