//
//  VoiceRecordingView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct VoiceRecordingView: View {
    @StateObject var viewModel = AudioTrackViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                titleSegment
//                Spacer()
                AudioTrackView(viewModel: viewModel)
                    .padding()
                navigationButtons
//                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DtLogoView()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .onAppear {
            viewModel.fileExists()
        }

    }
}

#Preview {
    NavigationStack {
        VoiceRecordingView()
    }
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
            DtButton(title: "Proceed".localize(), style: viewModel.fileExistsBool ? .main : .secondary) {
                // TODO: - Proceed button action
            }
        }
    }
}
