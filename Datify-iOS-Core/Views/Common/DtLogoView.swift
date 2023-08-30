//
//  DtLogoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 29.08.2023.
//

import SwiftUI

struct DtLogoView: View {
    var body: some View {
        HStack {
            Image("logoImage")
                .resizable()
                .frame(
                    width: AppConstants.Visual.logoSideSize,
                    height: AppConstants.Visual.logoSideSize
                )
            Text("Datify")
                .dtTypo(.h3Medium, color: .textPrimary)
        }
    }
}

struct DtLogoView_Previews: PreviewProvider {
    static var previews: some View {
        DtLogoView()
    }
}
