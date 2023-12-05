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
    @State private var complainCase: ComplainCases?
    @State private var complainText: String = .init()
    @FocusState private var textFieldIsFocused: Bool
    let onCompleted: () -> Void

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

    enum ComplainCases: String, CaseIterable {
        case fake = "Fake"
        case unacceptableContent = "Unacceptable content"
        case age = "Age"
        case insults = "Insults"
        case behavior = "Behavior outside of Datify"
        case scamSpam = "Scam or spam"

        var complainDetails: [String] {
            switch self {
            case .fake:
                ["Some 'Fake' details"]
            case .unacceptableContent:
                ["Some 'Unacceptable content' details"]
            case .age:
                ["Some Age details"]
            case .insults:
                ["Some 'Insults' details"]
            case .behavior:
                ["Some 'Behavior outside of Datify' details"]
            case .scamSpam:
                [
                    "Sends spam and suspicious links",
                    "Sells goods or services",
                    "Promotes social media accounts",
                    "Other"
                ]
            }
        }
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
                ForEach(ComplainCases.allCases, id: \.rawValue) { complainCase in
                    Button {
                        self.complainCase = complainCase
                        complaintStage = .intermediate
                    } label: {
                        HStack {
                            Text(complainCase.rawValue)
                                .dtTypo(.p2Medium, color: .textPrimary)
                            Spacer()
                            Image(DtImage.arrowRight)
                        }
                    }
                }
            }
        case .intermediate:
            VStack(alignment: .leading, spacing: 24) {
                if let complainCase {
                    ForEach(complainCase.complainDetails, id: \.self) { detail in
                        Button {
                            // TODO: action
                            complaintStage = .finish
                        } label: {
                            Text(detail)
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
