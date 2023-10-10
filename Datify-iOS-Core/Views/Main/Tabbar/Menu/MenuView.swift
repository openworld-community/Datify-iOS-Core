//
//  MenuView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: MenuViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: MenuViewModel(router: router))
    }

    var body: some View {
        Text("MenuView")
            .dtTypo(.h1Medium, color: .customWhite)
    }
}

#Preview {
    MenuView(router: Router())
}
