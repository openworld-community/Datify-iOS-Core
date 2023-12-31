//
//  SelectGenderView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 09.09.2023.
// 

import SwiftUI

enum Gender: Equatable, CaseIterable, Hashable {
    case male
    case female
    case nonbinary
    case transgender
    case bigender
    case genderless
    case other(String)

    static let allCases: [Gender] = [
        .male,
        .female,
        .nonbinary,
        .transgender,
        .bigender,
        .genderless,
        .other("Other...")
    ]

    static let otherGenders: [Gender] = [
        .nonbinary,
        .transgender,
        .bigender,
        .genderless,
        .other("Other...")
    ]

    var title: String {
        switch self {
        case .male: return "Male".localize()
        case .female: return "Female".localize()
        case .nonbinary: return "Non-binary".localize()
        case .transgender: return "Transgender".localize()
        case .bigender: return "Bigender".localize()
        case .genderless: return "Genderless".localize()
        case .other(let value): return value.localize()
        }
    }
}

struct RegSelectGenderView: View {
    enum Sheets: Identifiable {
        case otherOptions
        case termsAndConditions
        case enterGenderTitle

        var id: Sheets {
            return self
        }
    }

    @State private var sheet: Sheets?
    @State private var selectedGender: Gender?
    @State private var otherOptionsTitle: String = "Other options".localize()
    private let selectGenderTitle: String = "Select gender".localize()
    unowned let router: Router<AppRoute>

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(selectGenderTitle)
                .dtTypo(.h2Regular, color: .textPrimary)
            genderButtons
            otherOptionsLabel
            Spacer()
            termsAndConditionsLabel
            backProceedButtons
        }
        .padding(.bottom)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .onChange(of: selectedGender, perform: { newValue in
            switch newValue {
            case .other(let value): otherOptionsTitle = "Other option: \(value)".localize()
            case .male, .female, nil: otherOptionsTitle = "Other options".localize()
            default: otherOptionsTitle = "Other option: \(selectedGender?.title ?? "")".localize()
            }
        })
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .otherOptions:
                OtherGendersSheet(selectedGender: $selectedGender, sheet: $sheet)
            case .termsAndConditions:
                DtTermsAndConditions()
                    .padding(.top)
                    .presentationDetents([.fraction(0.99)])
            case .enterGenderTitle:
                EnterOtherGenderSheet(selectedGender: $selectedGender, sheet: $sheet)
            }
        }
    }
}

struct RegSelectGenderView_Previews: PreviewProvider {
    static var previews: some View {

        NavigationStack {
            RegSelectGenderView(router: Router())
        }
    }
}

private extension RegSelectGenderView {
    // MARK: - Male and Female gender buttons
    var genderButtons: some View {
        HStack(spacing: 16) {
            DtButton(title: Gender.male.title, style: selectedGender == .male ? .main : .picker) {
                selectedGender = .male
            }
            DtButton(title: Gender.female.title, style: selectedGender == .female ? .main : .picker) {
                selectedGender = .female
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Other options picker label
    var otherOptionsLabel: some View {
        Button(otherOptionsTitle) {
            sheet = .otherOptions
        }
        .dtTypo(.p3Regular, color: .textPrimaryLink)
    }

    // MARK: - Terms and conditions label and sheet
    var termsAndConditionsLabel: some View {
        HStack(spacing: 0) {
            Text("By registering, you accept the ")
                .dtTypo(.p4Regular, color: .textSecondary)
            Button {
                sheet = .termsAndConditions
            } label: {
                Text("terms and conditions")
                    .dtTypo(.p4Regular, color: .textPrimaryLink)
            }
        }
    }

    // MARK: - Bottom buttons, back arrow and proceed
    var backProceedButtons: some View {
        HStack(spacing: 8) {
            DtBackButton {
                router.pop()
            }
            DtButton(title: "Continue".localize(), style: .main) {
                // TODO: - Proceed button action
                router.push(.registrationName)
            }
                .disabled(selectedGender == nil)
        }
        .padding(.horizontal)
    }
}

private struct OtherGendersSheet: View {
    @State private var otherGender: Gender = .nonbinary
    @Binding var selectedGender: Gender?
    @Binding var sheet: RegSelectGenderView.Sheets?
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $otherGender) {
                ForEach(Gender.otherGenders, id: \.self) {
                    Text($0.title).tag($0)
                        .dtTypo(.p1Regular, color: .textPrimary)
                }
            }
            DtButton(title: "Select gender".localize(), style: .primary) {
                switch otherGender {
                case .other: sheet = .enterGenderTitle
                default:
                    selectedGender = otherGender
                    sheet = nil
                }
            }
            .padding(.horizontal)
        }
        .pickerStyle(.wheel)
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
}

private struct EnterOtherGenderSheet: View {
    @State private var otherGenderTitle: String = .init()
    @Binding var selectedGender: Gender?
    @Binding var sheet: RegSelectGenderView.Sheets?
    var body: some View {
        VStack {
            Text("Enter gender from 3 to 15 characters long")
                .dtTypo(.p2Regular, color: .textSecondary)
            DtCustomTF(style: .text("Enter gender".localize(), .leading), input: $otherGenderTitle)
            HStack {
                DtBackButton(action: {sheet = .otherOptions})
                DtButton(title: "Proceed".localize(), style: .main, action: {
                    if genderTitleIsCorrect() {
                        selectedGender = .other(otherGenderTitle.trimWhitespace())
                        sheet = nil
                    }
                }).disabled(!genderTitleIsCorrect())
            }
        }
        .onChange(of: otherGenderTitle, perform: { newValue in
            otherGenderTitle = newValue.trimLeadingSpaces()
        })
        .padding(.horizontal)
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
    }

    private func genderTitleIsCorrect() -> Bool {
            otherGenderTitle.count >= 3 && otherGenderTitle.count < 15
        }
}
