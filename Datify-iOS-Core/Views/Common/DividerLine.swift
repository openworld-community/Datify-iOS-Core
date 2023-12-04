//
//  DividerLine.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 06.09.2023.
//

import SwiftUI

struct DividerLine: View {
    private let color: Color = .backgroundStroke
    private let width: CGFloat = 1

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .padding()
    }
}

struct DividerLine_Previews: PreviewProvider {
    static var previews: some View {
        DividerLine()
    }
}
