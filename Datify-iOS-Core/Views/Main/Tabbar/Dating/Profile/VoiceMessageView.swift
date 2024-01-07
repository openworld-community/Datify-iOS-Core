//
//  VoiceMessageView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 06.01.2024.
//

import SwiftUI

struct VoiceMessageView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundSecondary)
                .frame(height: 48)

            HStack {
                Text("00:10")

                Spacer()

                Image("exampleAudio")

                Spacer()

                Button(action: {

                }) {
                    Image(DtImage.playViolet)
                }
                .frame(width: 24)
            }
            .padding(.leading)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    VoiceMessageView()
}
