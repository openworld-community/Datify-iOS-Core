//
//  TermsAndConditions.swift
//  Datify-iOS-Core
//
//  Created by Илья on 11.09.2023.
//

import SwiftUI

struct TermsAndConditions: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Datify Dating App Terms and Conditions")
                    .multilineTextAlignment(.center)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Text(AppConstants.Text.termsAndConditions)
                .multilineTextAlignment(.leading)
                .dtTypo(.p5Regular, color: .accentsBlack)
            }
            .padding(.horizontal)
        }
    }
}

struct TermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}
