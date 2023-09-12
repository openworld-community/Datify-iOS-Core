//
//  String+extension.swift
//  Datify-iOS-Core
//
//  Created by Илья on 12.09.2023.
//

import Foundation

extension String {
    func localize() -> String {
        String(localized: String.LocalizationValue(self))
    }
}
