//
//  DtFileManager.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 13.12.2023.
//

import Foundation

class DtFileManager {
    func filePath(forResource resource: String, ofType type: String) -> String? {
        return Bundle.main.path(forResource: resource, ofType: type)
    }
}
