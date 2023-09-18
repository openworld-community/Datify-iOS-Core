//
//  RegFinalView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 19.09.2023.
//

import SwiftUI

struct RegFinalView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Spacer()
                VStack {
                    Text("Your profile is created,")
                        .dtTypo(geometry.size.width > 375 ? .h1Medium : .h2Medium, color: .textPrimary)
                    Text("congratulations!")
                        .foregroundLinearGradient()
                        .dtTypo(geometry.size.width > 375 ? .h1Medium : .h2Medium, color: .textPrimary)
                }
                secondaryText
                Spacer()
                bottomButtons
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .multilineTextAlignment(.center)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

struct RegFinalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegFinalView()
        }
    }
}

extension RegFinalView {
    var secondaryText: some View {
        Text("Fill out your profile and tell us more about yourself now or go straight to the search")
            .dtTypo(.p2Regular, color: .textSecondary)
            .padding(.horizontal)
    }

    var bottomButtons: some View {
        VStack(spacing: 10) {
            DtButton(title: "Fill out your profile".localize(), style: .main) {
                // TODO: - Fill profile button action
            }
            Button {
                // TODO: - Later button action
            } label: {
                Text("I'll fill it out later")
                    .dtTypo(.p2Medium, color: .textPrimary)
                    .frame(maxWidth: .infinity, minHeight: AppConstants.Visual.buttonHeight)
            }
        }
    }
}
