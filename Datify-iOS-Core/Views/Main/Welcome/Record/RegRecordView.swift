//
//  RegRecordView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RegRecordView: View {
    @StateObject private var viewModel: PowerGraphViewModel

    init(router: Router<AppRoute>) {
        let powerGraphModel = PowerGraphModel(widthElement: 3, heightGraph: 160, wightGraph: UIScreen.main.bounds.width, distanceElements: 2, deleteDuration: 0.5, recordingDuration: 15)
        self._viewModel = StateObject(wrappedValue: PowerGraphViewModel(router: router, powerGraphModel: powerGraphModel))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                titleSegment
                    .padding()
                RecordPowerGraphView(viewModel: viewModel)
                    .padding()
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
}

#Preview {
    NavigationStack {
        RegRecordView(router: Router())
    }
}

private extension RegRecordView {
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
            DtButton(title: "Proceed".localize(), style: viewModel.powerGraphModel.fileExistsBool ? .main : .secondary) {
                // TODO: - Proceed button action
            }
            .disabled(!viewModel.powerGraphModel.fileExistsBool)
        }
    }
}
