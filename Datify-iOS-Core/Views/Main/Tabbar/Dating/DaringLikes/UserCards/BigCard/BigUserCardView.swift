//
//  BigUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct BigUserCardView: View {
    @ObservedObject private var vm: SmallUserViewModel
    @Binding private var selected: String?
    @Binding private var blurRadius: CGFloat
    @Binding private var showInformationView: Bool
    private var size: CGSize

    init(selectedItem: Binding<String?>,
         size: CGSize,
         showInformationView: Binding<Bool>,
         blurRadius: Binding<CGFloat>) {
        _selected = selectedItem
        _showInformationView = showInformationView
        _blurRadius = blurRadius
        self.size = size
        vm = SmallUserViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        vm.getUser(userId: selected ?? "1")
    }

    var body: some View {
        VStack {
            if selected != nil {
                ZStack(alignment: .topTrailing) {
                    Image(vm.user?.photos.first ?? "user5")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width * 0.92, height: size.height * 0.85)
                        .cornerRadius(10)
                        .animation(.none, value: selected)
                    Button(action: {
                        // TODO: Create a function to check whether a chat exists with a user
                            showInformationView = true
                        withAnimation {
                            blurRadius = 10
                        }
                    }, label: {
                        Image("chatIcon")
                            .frame(width: 48, height: 48)
                            .padding()
                    })
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
                DtButton(title: "Continue".localize(), style: .main) { }
                .frame(width: size.width * 0.92)
            }
        }
    }
}

#Preview {
    BigUserCardView(selectedItem: .constant("1"),
                    size: CGSize(width: 313, height: 714),
                    showInformationView: .constant(false),
                    blurRadius: .constant(0))
}

#Preview {
    BigUserCardView(selectedItem: .constant(nil),
                    size: CGSize(width: 313, height: 714),
                    showInformationView: .constant(false),
                    blurRadius: .constant(0))
}
