//
//  Array+extension.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 19.11.2023.
//

import Foundation

extension Array {
    var isNotEmpty: Bool { !self.isEmpty }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
