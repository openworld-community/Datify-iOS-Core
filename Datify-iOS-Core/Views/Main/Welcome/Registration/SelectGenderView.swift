//
//  SelectGenderView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 09.09.2023.
// 

import SwiftUI

struct SelectGenderView: View {
    
    @State private var selectedGender = ""
    @State private var showTermsSheet = false
    @State private var showOtherOptionsSheet = false
    @State private var otherGender = ""
    private let selectGenderTitle = "Select gender"
    private let otherOptionsTitle = "Other options"
    
    var body: some View {
        VStack(spacing: 20){
            DtLogoView()
            Spacer(minLength: 230)
            Text(selectGenderTitle)
                .dtTypo(.h2Medium, color: .textPrimary)
            genderButtons
            otherOptionsPicker
            Spacer()
            termsAndConditionsLabel
            backProceedButtons
        }
    }
}

struct SelectGenderView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGenderView()
    }
}

extension SelectGenderView {
    
    //MARK: - Male and Female gender buttons
    private var genderButtons: some View {
        HStack(spacing: 15) {
            DtButton(title: "Male", height: AppConstants.Visual.buttonHeight, style: .picker, isActivated: selectedGender == "Male" ? true : false) {
                selectedGender = "Male"
            }
            DtButton(title: "Female", height: AppConstants.Visual.buttonHeight, style: .picker, isActivated: selectedGender == "Female" ? true : false) {
                selectedGender = "Female"
            }
        }
        .padding(.horizontal)
    }
    
    //MARK: - Other options picker label and sheet
    private var otherOptionsPicker: some View {
        Button(otherOptionsTitle) {
            showOtherOptionsSheet.toggle()
        }
        .dtTypo(.p3Regular, color: .textPrimaryLink)
        .sheet(isPresented: $showOtherOptionsSheet) {
            VStack (spacing: 0) {
                Picker("Other options", selection: $otherGender) {
                    Text("Non-binary").tag("Non-binary")
                    Text("Transgender").tag("Transgender")
                    Text("Bigender").tag("Bigender")
                    Text("Genderless").tag("Genderless")
                    Text("Other").tag("Other")
                }
                .pickerStyle(.wheel)
                .presentationDetents([.fraction(0.36)])
                .presentationDragIndicator(Visibility.visible)
                DtButton(title: "Select gender", style: .primary) {
                    selectedGender = otherGender
                    showOtherOptionsSheet.toggle()
                }
                .padding(.horizontal)
            }
        }
    }
    
    //MARK: - Terms and conditions label and sheet
    private var termsAndConditionsLabel: some View {
        HStack(spacing: 0) {
            Text("By registering, you accept the ")
                .dtTypo(.p4Medium, color: .textSecondary)
            Text("terms and conditions")
                .dtTypo(.p4Medium, color: .textPrimaryLink)
                .onTapGesture {
                    showTermsSheet.toggle()
                }
        }
        .sheet(isPresented: $showTermsSheet) {
            ScrollView{
                VStack (spacing: 20) {
                    Spacer()
                    termsAndConditions()
                }
            }
            .presentationDetents([.fraction(0.9)])
            .presentationDragIndicator(Visibility.visible)
        }
    }
        
    //MARK: - Bottom buttons, back arrow and proceed
    private var backProceedButtons: some View {
        HStack(spacing: 10) {
            Button {} label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .foregroundColor(.textPrimary)
                    .frame(width: AppConstants.Visual.buttonHeight,
                           height: AppConstants.Visual.buttonHeight)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(AppConstants.Visual.cornerRadius)
            }
            DtButton(title: "Proceed", style: .primary) {}
                .disabled(selectedGender == "")
        }
        .padding(.horizontal)
    }
}

struct termsAndConditions: View {
    var body: some View {
        Text("Datify Dating App Terms and Conditions")
            .multilineTextAlignment(.center)
            .dtTypo(.p1Regular, color: .textPrimary)
        Text(AppConstants.Text.termsAndConditions)
        .multilineTextAlignment(.leading)
        .dtTypo(.p5Regular, color: .accentsBlack)
        .padding(.horizontal)
    }
}
