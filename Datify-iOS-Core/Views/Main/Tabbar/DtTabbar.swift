//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 07.10.2023.
//

import SwiftUI

struct DtTabbar<Content: View>: View {
    let tabsData: [TabItem]
    @Binding var selectedTab: TabItem
    @ObservedObject var viewModel: TabbarViewModel
    let tabView: (TabItem) -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack {
                tabView(selectedTab)
                ZStack(alignment: .bottom) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(tabsData, id: \.self) { datum in
                            ZStack(alignment: .center) {
                                DtTabItem(
                                    tabItem: datum,
                                    selectedTab: $selectedTab,
                                    itemWidth: geometry.size.width / CGFloat(tabsData.count))
                                if case .chat = datum {
                                    alarmUnreadCountView()
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .background(Color.customWhite)
            }
        }
    }

    @ViewBuilder
    private func alarmUnreadCountView() -> some View {
        ZStack {
            switch viewModel.alarmsUnreadCountState {
            case .noAlarms:
                EmptyView()
            case let .count(count):
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                    Text("\(count)")
                }
            default:
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .frame(width: 32, height: 20)
                    Text("99+")
                }
            }
        }
        .frame(width: 32, height: 20, alignment: .trailing)
        .padding(8)
    }
}

private struct DtTabItem: View {
    let tabItem: TabItem
    @Binding var selectedTab: TabItem
    let itemWidth: CGFloat

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
                        .foregroundStyle(selectedTab == tabItem ? Color.customBlack : Color.customGray)
                }
                Text(tabItem.title())
                    .dtTypo(.p5Medium, color: (selectedTab == tabItem ? Color.customBlack : Color.customGray))
                    .foregroundStyle(selectedTab == tabItem ? Color.customBlack : Color.customGray)
            }
            .frame(width: itemWidth)
        }
        .buttonStyle(.plain)
    }
}
