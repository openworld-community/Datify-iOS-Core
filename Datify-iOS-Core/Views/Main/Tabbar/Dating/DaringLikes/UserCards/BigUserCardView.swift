//
//  BigUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct BigUserCardView: View {
    @ObservedObject var vm: UserCardViewModel
    @Binding var selected: String?
    var size: CGSize

    init(selectedItem: Binding<String?>, size: CGSize) {
        _selected = selectedItem
        self.size = size
        vm = UserCardViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        vm.getUser(userId: selected ?? "1")
    }

    var body: some View {
        HStack {
            Image(vm.user?.photos.first ?? "user5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width*0.92, height: size.height*0.81)
                .cornerRadius(10)
                .animation(.none, value: selected)
        }
    }
}
