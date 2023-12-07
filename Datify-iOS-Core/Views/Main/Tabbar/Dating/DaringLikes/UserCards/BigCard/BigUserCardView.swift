//
//  BigUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct BigUserCardView: View {
    @ObservedObject var vm: SmallUserViewModel
    @Binding var selected: String?
    var size: CGSize

    init(selectedItem: Binding<String?>, size: CGSize) {
        _selected = selectedItem
        self.size = size
        vm = SmallUserViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        vm.getUser(userId: selected ?? "1")
    }

    var body: some View {
        VStack {
            if selected != nil {
                Image(vm.user?.photos.first ?? "user5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 0.92, height: size.height * 0.85)
                    .cornerRadius(10)
                    .animation(.none, value: selected)
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
                DtButton(title: "Continue".localize(), style: .main) { }
                .frame(width: size.width * 0.92)
            }
        }
    }
}

#Preview {
    BigUserCardView(selectedItem: .constant("1"), size: CGSize(width: 313, height: 714))
}

#Preview {
    BigUserCardView(selectedItem: .constant(nil), size: CGSize(width: 313, height: 714))
}
