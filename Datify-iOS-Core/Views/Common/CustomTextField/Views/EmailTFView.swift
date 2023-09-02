//
//  EmailTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .border(Color.gray, width: 1)
    }
}
