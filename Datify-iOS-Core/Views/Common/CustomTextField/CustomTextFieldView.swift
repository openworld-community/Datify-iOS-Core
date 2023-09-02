//
//  CustomTextFieldView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 31.08.2023.
//

import SwiftUI

enum CustomTFStyle: CaseIterable {
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
    var placeholder: String
    var style: CustomTFStyle
    
    var body: some View {
        switch style {
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


struct CustomTF_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(CustomTFStyle.allCases, id: \.self) { style in
                CustomTF(text: .constant("Example"), placeholder: "Placeholder", style: style)
                    .previewDisplayName(style.displayName)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}

extension CustomTFStyle {
    var displayName: String {
        switch self {
        case .phoneAndEmail:
            return "Phone and Email Style"
        case .email:
            return "Email Style"
        case .password:
            return "Password Style"
        case .name:
            return "Name Style"
        case .phone:
            return "Phone Style"
        case .sms:
            return "SMS Style"
        case .answer:
            return "Answer Style"
        }
    }
}


