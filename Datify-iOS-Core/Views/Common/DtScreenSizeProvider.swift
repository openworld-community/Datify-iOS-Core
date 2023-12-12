//
//  DtScreenSizeProvider.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 12.12.2023.
//

import SwiftUI

protocol ScreenSizeProvider {
    var screenWidth: CGFloat { get }
    var screenHeight: CGFloat { get }
}

struct DtScreenSizeProvider: ScreenSizeProvider {
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}
