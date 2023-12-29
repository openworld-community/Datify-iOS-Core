//
//  ChatView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ChatViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("ChatView")
                    .dtTypo(.h1Medium, color: .customBlack)
                Spacer()
            }

            Spacer()
        }
//        .frame(maxHeight: .infinity)
        .background(.green)
    }
}

#Preview {
    ChatView(router: Router())
}
