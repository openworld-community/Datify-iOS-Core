//
//  String+extension.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 11.09.2023.
//

import Foundation
import UIKit

extension String {
    func localize() -> String {
        String(localized: String.LocalizationValue(self))
    }

    var isNotEmpty: Bool {
        !self.isEmpty
    }

    func trimLeadingSpaces() -> String {
        guard let index = firstIndex(where: {
            !CharacterSet(charactersIn: String($0))
                .isSubset(of: .whitespaces)
        }) else {
            return self
        }
        return String(self[index...])
    }

    /// Transforms "my____name____is___Ilya___" to "my_name_is_Ilya"
    /// - Returns: String with no multiple nor trailing whitespaces
    func trimWhitespace() -> String {
        return self
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Transforms "my____name____is___iLyA___sirotkin" to "My_Name_Is_Ilya_Sirotkin"
    /// - Returns: String with no multiple nor trailing whitespaces, every word is capitalized
    func trimWhitespaceCapit() -> String {
        return self.trimWhitespace().capitalized
    }

    func getSize(fontSize: CGFloat = 16, fontWeight: UIFont.Weight) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }

}
