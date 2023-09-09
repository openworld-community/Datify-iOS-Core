//
//  PreviewCTF.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct ContentViewCTF: View {
    @State private var input = ""

    var body: some View {
        PreviewCTF(input: $input)
    }
}

struct ContentViewCTF_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCTF()
    }
}

struct PreviewCTF: View {
    @Binding var input: String

    var body: some View {
        VStack {
            DtCustomTF(
                input: $input,
                style: .email
            )
            .padding(.horizontal, AppConstants.Visual.paddings)
            DtCustomTF(
                input: $input,
                style: .phone
            )
            .padding(.horizontal, AppConstants.Visual.paddings)
            DtCustomTF(
                input: $input,
                style: .text
            )
            .padding(.horizontal, AppConstants.Visual.paddings)
        }
    }
}
