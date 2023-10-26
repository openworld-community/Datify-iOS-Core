//
//  View+extension.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.09.2023.
//

import SwiftUI

extension View {
    func hideKeyboardTapOutside() -> some View {
        onTapGesture { UIApplication.shared.dismissKeyboard() }
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
