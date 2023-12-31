//
//  RegFinalView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 19.09.2023.
//

import SwiftUI

struct RegFinalView: View {
    unowned let router: Router<AppRoute>
    private let title1: String = "Your profile is created,".localize()
    private let title2: String = "congratulations!".localize()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Spacer()
                VStack {
                    Text(title1)
                        .minimumScaleFactor(0.5)
                    Text(title2)
                        .foregroundLinearGradient()
                        .scaleEffect(scaleOfTitle(screenWidth: geometry.size.width, title: title1))
                }
                .lineLimit(1)
                .dtTypo(.h1Medium, color: .textPrimary)

                secondaryText
                Spacer()
                bottomButtons
                    .padding(.bottom)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)

        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }

    private func scaleOfTitle(screenWidth: CGFloat, title: String) -> CGFloat {
        let titleSize = title.getSize(fontSize: 36, fontWeight: .medium)
        var scale = screenWidth/(titleSize + 40)
        if scale > 1 {
            scale = 1
        } else if scale < 0.5 {
            scale = 0.5
        }
        return scale
    }
}

struct RegFinalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegFinalView(router: Router())
        }
    }
}

private extension RegFinalView {
    var secondaryText: some View {
        Text("Fill out your profile and tell us more about yourself now or go straight to the search")
            .dtTypo(.p2Regular, color: .textSecondary)
    }

    var bottomButtons: some View {
        VStack(spacing: 10) {
            DtButton(title: "Fill out your profile".localize(), style: .main) {
                // TODO: - Fill profile button action
                router.push(.temp)
            }
            DtButton(title: "I'll fill it out later".localize(), style: .other) {
                // TODO: - Later button action
                router.push(.tabbar)
            }
        }
    }
}
