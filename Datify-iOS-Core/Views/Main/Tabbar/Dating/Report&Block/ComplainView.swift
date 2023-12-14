//
//  ComplainView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 04.12.2023.
//

import SwiftUI

struct ComplainView: View {
    @Binding var isPresented: Bool
    @State private var complaintStage: ComplaintStages = .start
    @State private var complaint: ComplaintModel?
    @State private var complainText: String = .init()
    @FocusState private var textFieldIsFocused: Bool
    let onCompleted: () -> Void

    private let complaintData: [ComplaintModel] = [
        .init(complaintType: .fake, adInfo: Complaint.Fake.allCases),
        .init(complaintType: .unacceptableContent, adInfo: Complaint.UnacceptableContent.allCases),
        .init(complaintType: .age, adInfo: Complaint.Age.allCases),
        .init(complaintType: .insults, adInfo: Complaint.Insults.allCases),
        .init(complaintType: .behavior, adInfo: Complaint.Behavior.allCases),
        .init(complaintType: .scamSpam, adInfo: Complaint.ScamSpam.allCases)
    ]

    var body: some View {
        VStack(spacing: 28) {
            header
            getDetails()
        }
        .padding()
    }
}

#Preview {
    ComplainView(isPresented: .constant(true), onCompleted: {})
}

private extension ComplainView {
    enum ComplaintStages {
        case start, intermediate, finish
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Complain")
                    .dtTypo(.h3Medium, color: .textPrimary)
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.backgroundSecondary)
                            .frame(width: 32)
                        Image(systemName: DtImage.xmark)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color.iconsSecondary)
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Your appeal")
                    .dtTypo(.p3Regular, color: .textSecondary)
                Text("is completely anonymous")
                    .dtTypo(.p3Regular, color: .accentsViolet)
            }
        }
    }

    @ViewBuilder
    func getDetails() -> some View {
        switch complaintStage {
        case .start:
            VStack(alignment: .leading, spacing: 24) {
                ForEach(complaintData, id: \.complaintType) { complaint in
                    Button {
                        self.complaint = complaint
                        complaintStage = .intermediate
                    } label: {
                        HStack {
                            Text(complaint.complaintType.title)
                                .dtTypo(.p2Medium, color: .textPrimary)
                            Spacer()
                            Image(DtImage.arrowRight)
                        }
                    }
                }
            }
        case .intermediate:
            VStack(alignment: .leading, spacing: 24) {
                if let complaint {
                    ForEach(complaint.adInfo, id: \.hashValue) { adInfo in
                        Button {
                            // TODO: action
                            complaintStage = .finish
                        } label: {
                            Text(adInfo.rawValue)
                                .dtTypo(.p2Medium, color: .textPrimary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .finish:
            VStack(alignment: .leading, spacing: 12) {
                TextField("Describe your case in detail...", text: $complainText, axis: .vertical)
                    .dtTypo(.p2Regular, color: .textPrimary)
                    .frame(height: 188, alignment: .topLeading)
                    .padding()
                    .background(Color.backgroundSecondary)
                    .cornerRadius(AppConstants.Visual.cornerRadius)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: AppConstants.Visual.cornerRadius
                        )
                        .stroke(Color.backgroundStroke, lineWidth: 1)
                    )
                    .focused($textFieldIsFocused)

                if !textFieldIsFocused {
                    DtButton(title: "Send a complaint", style: .main) {
                        // TODO: action
                        Task { @MainActor in
                            isPresented = false
                            onCompleted()
                        }
                    }
                }
            }
            .hideKeyboardTapOutside()
        }
    }
}
