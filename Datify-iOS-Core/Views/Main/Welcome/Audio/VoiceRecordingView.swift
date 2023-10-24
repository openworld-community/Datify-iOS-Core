//
//  VoiceRecordingView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct VoiceRecordingView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            titleSegment
            Spacer()
            HStack {
                
            }
            navigationButtons
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview {
    VoiceRecordingView()
}

private extension VoiceRecordingView {
    var titleSegment: some View {
        VStack(spacing: 8) {
            Text("Record a voice message for other people")
                .dtTypo(.h3Regular, color: .textPrimary)
            Text("Your voice message will be listened, to find out more about you")
                .dtTypo(.p3Regular, color: .textSecondary)
        }
        .multilineTextAlignment(.center)
    }
    var navigationButtons: some View {
        HStack(spacing: 8) {
            DtBackButton {
                // TODO: - Back button action
            }
            DtButton(title: "Proceed".localize(), style: .main) {
                // TODO: - Proceed button action
            }
        }
    }
}
