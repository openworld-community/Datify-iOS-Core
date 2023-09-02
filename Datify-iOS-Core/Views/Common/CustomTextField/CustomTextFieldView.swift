//
//  CustomTextFieldView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 31.08.2023.
//

import SwiftUI

enum CustomTFType: CaseIterable {
    case phoneAndEmail
    case email
    case password
    case name
    case phone
    case sms
    case answer
}

struct CustomTF: View {
    @Binding var text: String
    let placeholder: String
    var type: CustomTFType
    
    var body: some View {
        switch type {
            case .phoneAndEmail:
                TextField(placeholder, text: $text)
                    .padding()
            case .email:
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            case .password:
                TextField(placeholder, text: $text)
                    .padding()
                    .overlay(Rectangle().frame(height: 1).padding(.top, 30), alignment: .top)
            case .name:
                TextField(placeholder, text: $text)
                    .padding()
                    .overlay(Rectangle().frame(height: 1).padding(.top, 30), alignment: .top)
            case .phone:
                TextField(placeholder, text: $text)
                    .padding()
                    .overlay(Rectangle().frame(height: 1).padding(.top, 30), alignment: .top)
            case .answer:
                TextField(placeholder, text: $text)
                    .padding()
                    .overlay(Rectangle().frame(height: 1).padding(.top, 30), alignment: .top)
            case .sms:
                TextField(placeholder, text: $text)
                    .padding()
                    .overlay(Rectangle().frame(height: 1).padding(.top, 30), alignment: .top)
        }
    }
}


