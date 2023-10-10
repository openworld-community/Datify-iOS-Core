//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 07.10.2023.
//

import SwiftUI

struct TrTabbar<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let tabsData: [TabItem]
    @Binding var selectedTab: TabItem
    @ObservedObject var model: TabbarViewModel
    let tabView: (TabItem) -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack {
                tabView(selectedTab)
                Spacer()
                HStack(alignment: .center) {
                    ForEach(tabsData, id: \.self) { datum in
                        ZStack(alignment: .topTrailing) {
                            TrTabItem(
                                tabItem: datum,
                                selectedTab: $selectedTab,
                                itemWidth: geometry.size.width / CGFloat(tabsData.count),
                                badgeCount: 0
                            )
                        }
                    }
                }
            }
        }
    }
}

private struct TrTabItem: View {
    @Environment(\.colorScheme) var colorScheme
    let tabItem: TabItem
    @Binding var selectedTab: TabItem
    let itemWidth: CGFloat
    let badgeCount: Int

    var body: some View {
        Button {
                selectedTab = tabItem
        } label: {
            VStack(alignment: .center, spacing: 2.0) {
                ZStack {
                    Image(tabItem.image(isSelected: selectedTab == tabItem))
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(selectedTab == tabItem ? Color.textPrimary : Color.textTertiary)

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
                Text(tabItem.title())
                    .dtTypo(.p5Medium, color: (selectedTab == tabItem ? .textPrimary : .textTertiary))
                    .foregroundStyle(selectedTab == tabItem ? Color.textPrimary : Color.textTertiary)
            }
            .frame(width: itemWidth)
        }
        .buttonStyle(.plain)
    }
}

struct TrTabbar_Previews: PreviewProvider {
    static let tabs = TabItem.allCases

    static var previews: some View {
        let selectedTab: Binding<TabItem> = .constant(.chat)

        return Group {
            TrTabbar(
                tabsData: tabs,
                selectedTab: selectedTab,
                model: TabbarViewModel(router: Router(), selectedTab: .chat)
            ) { item in
                Text(item.title())
            }
            .navigationBarHidden(true)
        }
    }
}
