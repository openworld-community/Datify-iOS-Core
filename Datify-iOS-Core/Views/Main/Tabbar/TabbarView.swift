//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 07.10.2023.
//

import SwiftUI

enum TabType: String {
    case dating = "Dating"
    case chat = "Chat"
    case menu = "Menu"
 }

struct TabbarView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: TabType = .dating

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment.bottom) {
                TabView(selection: $selectedTab) {
                    dating.tag(TabType.dating)
                    chat.tag(TabType.chat)
                    menu.tag(TabType.menu)
                }
                HStack(alignment: .center) {
                    TabBarItem(
                        icon: DtImage.tabbarDating,
                        title: "Dating".localize(),
                        badgeCount: 0,
                        isSelected: selectedTab == .dating,
                        itemWidth: geometry.size.width / 3) {
                            selectedTab = .dating
                        }

                    TabBarItem(
                        icon: DtImage.tabbarChat,
                        title: "Chat".localize(),
                        badgeCount: 10,
                        isSelected: selectedTab == .chat,
                        itemWidth: geometry.size.width / 3) {
                            selectedTab = .chat
                        }
                    TabBarItem(
                        icon: DtImage.tabbarMenu,
                        title: "Menu".localize(),
                        badgeCount: 0,
                        isSelected: selectedTab == .menu,
                        itemWidth: geometry.size.width / 3) {
                            selectedTab = .menu
                        }
                }
            }
        }
    }

    private var dating: some View {
         Text("Tab1")
            .dtTypo(.h1Regular, color: .textPrimary)
     }

    private var chat: some View {
         Text("Tab2")
            .dtTypo(.h1Regular, color: .textPrimary)
     }

     private var menu: some View {
         Text("Tab3")
             .dtTypo(.h1Regular, color: .textPrimary)
     }
}

struct TabBarItem: View {
    @Environment(\.colorScheme) var colorScheme

    let icon: String
    let title: String
    let badgeCount: Int
    let isSelected: Bool
    let itemWidth: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .center, spacing: 2.0) {
                ZStack {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isSelected ? Color.textPrimary : Color.textTertiary)

                    Text("\(badgeCount > 99 ? "99+" : "\(badgeCount)")")
                        .dtTypo(.p5Regular, color: .black)
                        .kerning(0.3)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal, 4)
                        .background(Color.accentsGreen)
                        .cornerRadius(50)
                        .opacity(badgeCount == 0 ? 0.0 : 1.0)
                        .offset(x: 19.0, y: -8.0)
                }
                Text(title)
                    .dtTypo(.p5Medium, color: (isSelected ? .textPrimary : .textTertiary))
                    .foregroundStyle(isSelected ? Color.textPrimary : Color.textTertiary)
            }
            .frame(width: itemWidth)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TabbarView()
}
