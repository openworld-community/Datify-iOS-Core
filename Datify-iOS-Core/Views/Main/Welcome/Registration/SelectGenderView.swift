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
        case .other(let value):
            return value.localizedCapitalized
        default:
            return self.description.localizedCapitalized
        }
    }

    var description: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .nonbinary: return "Non-binary"
        case .transgender: return "Transgender"
        case .bigender: return "Bigender"
        case .genderless: return "Genderless"
        case .other(let value): return value
        }
    }
}

struct SelectGenderView: View {
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
    @State private var otherOptionsTitle = "Other options"
    private let selectGenderTitle = "Select gender"

    var body: some View {
        VStack(spacing: 20) {
            DtLogoView()
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
        .onChange(of: selectedGender, perform: { newValue in
            switch newValue {
            case .other(let value): otherOptionsTitle = "Other option: \(value)"
            case .male, .female, nil: otherOptionsTitle = "Other options"
            default: otherOptionsTitle = "Other option: \(selectedGender?.title ?? "")"
            }
        })
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .otherOptions:
                OtherGendersSheet(selectedGender: $selectedGender, sheet: $sheet)
            case .termsAndConditions:
                TermsAndConditions()
                    .padding(.top)
                    .presentationDetents([.fraction(0.99)])
            case .enterGenderTitle:
                EnterOtherGenderSheet(selectedGender: $selectedGender, sheet: $sheet)
            }
        }
    }
}

struct SelectGenderView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGenderView()
    }
}

extension SelectGenderView {
    // MARK: - Male and Female gender buttons
    private var genderButtons: some View {
        HStack(spacing: 16) {
            DtButton(title: "Male", style: selectedGender == .male ? .main : .picker) {
                selectedGender = .male
            }
            DtButton(title: "Female", style: selectedGender == .female ? .main : .picker) {
                selectedGender = .female
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Other options picker label
    private var otherOptionsLabel: some View {
        Button(otherOptionsTitle) {
            sheet = .otherOptions
        }
        .dtTypo(.p3Regular, color: .textPrimaryLink)
    }

    // MARK: - Terms and conditions label and sheet
    private var termsAndConditionsLabel: some View {
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
    private var backProceedButtons: some View {
        HStack(spacing: 10) {
            DtBackButton {
                // TODO: - Back button action
            }
            DtButton(title: "Proceed", style: .main) {
                // TODO: - Proceed button action
            }
                .disabled(selectedGender == nil)
        }
        .padding(.horizontal)
    }
}

struct OtherGendersSheet: View {
    @State var otherGender: Gender = .nonbinary
    @Binding var selectedGender: Gender?
    @Binding var sheet: SelectGenderView.Sheets?
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $otherGender) {
                ForEach(Gender.otherGenders, id: \.self) { gender in
                    Text(gender.title).tag(gender)
                        .dtTypo(.p1Regular, color: .textPrimary)
                }
            }
            DtButton(title: "Select gender", style: .primary) {
                if otherGender == .other("Other...") {
                    sheet = .enterGenderTitle
                } else {
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

struct EnterOtherGenderSheet: View {
    @State private var otherGenderTitle = ""
    @Binding var selectedGender: Gender?
    @Binding var sheet: SelectGenderView.Sheets?
    var body: some View {
        VStack {
            Text("Enter gender from 3 to 15 characters long")
                .dtTypo(.p2Regular, color: .textSecondary)
            TextField("Enter gender", text: $otherGenderTitle)
                .dtTypo(.p2Medium, color: .textPrimary)
                .frame(height: AppConstants.Visual.buttonHeight)
                .padding(.leading)
                .background(Color.backgroundSecondary)
                .cornerRadius(AppConstants.Visual.cornerRadius)
            HStack {
                DtBackButton(action: {sheet = .otherOptions})
                DtButton(title: "Proceed", style: .main, action: {
                    if otherGenderTitle.count < 3 || otherGenderTitle.count > 15 {

                    } else {
                        selectedGender = .other(otherGenderTitle)
                        sheet = nil
                    }
                }).disabled(otherGenderTitle.count < 3 || otherGenderTitle.count > 15)
            }
        }
        .padding(.horizontal)
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
    }
}
