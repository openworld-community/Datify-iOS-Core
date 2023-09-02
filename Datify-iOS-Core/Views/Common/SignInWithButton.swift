//
//  SignInWithButton.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 01.09.2023.
//

import SwiftUI

struct SignInWithButton: View {

    let signInWithApple = "Sign in with Apple"
    let signInWithGoogle = "Sign in with Google"
    // numbers
    let frame15: CGFloat = 15
    let frame24: CGFloat = 24
    let frame21: CGFloat = 21
    let frame1: CGFloat = 1

    private let action: () async -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack(spacing: frame15) {
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
                            .frame(width: frame21, height: frame24)
                            .foregroundColor(Color.iconsPrimary)
                    } else {
                        Image(DtImage.googleLogo)
                            .resizable()
                            .frame(width: frame24, height: frame24)
                    }
                }
                Text("\(isApple ? signInWithApple : signInWithGoogle)")
                    .dtTypo(.p2Medium, color: .textPrimary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: AppConstants.Visual.buttonHeight)
        .padding(.horizontal, frame15)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .stroke(Color.secondary, lineWidth: frame1)
        )
    }
}
