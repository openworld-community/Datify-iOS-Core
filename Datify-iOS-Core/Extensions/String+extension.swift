//
//  String+extension.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 11.09.2023.
//

import Foundation

extension String {
    func localize() -> String {
        String(localized: String.LocalizationValue(self))
    }
  
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
