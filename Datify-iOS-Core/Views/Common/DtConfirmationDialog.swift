//
//  DtConfirmationDialog.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 01.12.2023.
//

import SwiftUI

struct DtConfirmationDialogModifier<A>: ViewModifier where A: View {
    @Binding var isPresented: Bool
    @ViewBuilder let actions: () -> A

    func body(content: Content) -> some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: isPresented ? 10 : 0)

            ZStack(alignment: .bottom) {
                if isPresented {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .black.opacity(0), location: 0),
                            Gradient.Stop(color: .black.opacity(0.7), location: 1)
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                    .transition(.opacity)

                    VStack(spacing: 12) {
                        Spacer()

                        GroupBox {
                            VStack(spacing: 0) {
                                actions()
                            }
                        }
                        .groupBoxStyle(DtGroupBoxStyle())
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius))

                        GroupBox {
                            Button(role: .cancel) {
                                isPresented = false
                            } label: {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical)
                            }
                            .dtTypo(.p2Medium, color: .textPrimary)
                        }
                        .groupBoxStyle(DtGroupBoxStyle())
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius))
                    }
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.easeOut(duration: 0.3), value: isPresented)
    }
}

extension View {
    func dtConfirmationDialog<A: View>(isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> A) -> some View {
        return self.modifier(
            DtConfirmationDialogModifier(
                isPresented: isPresented,
                actions: actions
            )
        )
    }
}
