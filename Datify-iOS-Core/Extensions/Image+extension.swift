//
//  Image+extension.swift
//  Datify-iOS-Core
//
//  Created by Илья on 12.09.2023.
//

import SwiftUI

extension Image {
    func resizableFit() -> some View {
        return resizable().scaledToFit()
    }

    func resizableFill() -> some View {
        return resizable().scaledToFill()
    }
}
