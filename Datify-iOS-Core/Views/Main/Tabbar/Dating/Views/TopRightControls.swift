//
//  TopRightControls.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct TopRightControls: View {
    var body: some View {
        HStack {
            Button(action: {
                // TODO: Show Filter View
            }, label: {
                Image(DtImage.mainFilter)
            })

            Button(action: {
                // TODO: Show Notification View
            }, label: {
                Image(DtImage.mainNotifications)
            })
        }
    }
}
