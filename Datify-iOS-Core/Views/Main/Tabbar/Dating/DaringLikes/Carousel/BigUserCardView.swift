//
//  BigUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct BigUserCardView: View {
    @ObservedObject private var viewModel: UserViewModel
    @Binding private var selectedItem: String?
    @Binding private var blurRadius: CGFloat
    @Binding private var showInformationView: Bool
    private var size: CGSize

    init(selectedItem: Binding<String?>,
         size: CGSize,
         showInformationView: Binding<Bool>,
         blurRadius: Binding<CGFloat>) {
        _selectedItem = selectedItem
        _showInformationView = showInformationView
        _blurRadius = blurRadius
        self.size = size
        viewModel = UserViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        if let selected = self.selectedItem {
            viewModel.getUser(userId: selected)
        }

    }

    var body: some View {
        VStack {
            if let user = viewModel.user {
                ZStack(alignment: .topTrailing) {
                    if let photo = user.photos.first {
                        Image(photo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width * 0.92, height: size.height * 0.85)
                            .cornerRadius(10)
                            .animation(.none, value: selectedItem)
                    }
                    Button(action: {
                        // TODO: Create a function to check whether a chat exists with a user
                        showInformationView = true
                        withAnimation {
                            blurRadius = 10
                        }
                    }, label: {
                        Image(DtImage.chatIcon)
                            .frame(width: 48, height: 48)
                            .padding()
                    })
                }
            }

        }
    }
}

#Preview {
    BigUserCardView(selectedItem: .constant("1"),
                    size: CGSize(width: 400, height: 800),
                    showInformationView: .constant(false),
                    blurRadius: .constant(0))
}

#Preview {
    BigUserCardView(selectedItem: .constant(nil),
                    size: CGSize(width: 400, height: 800),
                    showInformationView: .constant(false),
                    blurRadius: .constant(0))
}
