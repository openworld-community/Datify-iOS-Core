//
//  DismissKeyboard+extension.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.09.2023.
//

import UIKit

#if canImport(UIKit)
    extension UIApplication: UIGestureRecognizerDelegate {
        func dismissKeyboard() {
            sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
#endif
