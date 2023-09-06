//
//  SignInWithButton.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 01.09.2023.
//

import SwiftUI

struct SignInWithButton: View {

    private let signInWithApple: String = "Sign in with Apple"
    private let signInWithGoogle: String = "Sign in with Google"

    private let action: () async -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack(spacing: 15) {
            customButton(isApple: false)
            customButton(isApple: true)
        }
    }
}

struct SignInWithButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithButton(action: {})
    }
}

extension SignInWithButton {
    @ViewBuilder
    func customButton(isApple: Bool = false) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack {
                Group {
                    if isApple {
                        Image(systemName: DtImage.appleLogo)
                            .resizable()
                            .frame(width: 21, height: 24)
                            .foregroundColor(Color.iconsPrimary)
                    } else {
                        Image(DtImage.googleLogo)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                Text("\(isApple ? signInWithApple : signInWithGoogle)")
                    .dtTypo(.p2Medium, color: .textPrimary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: AppConstants.Visual.buttonHeight)
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}
