//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

// enum DtSheetType: String, Identifiable {
//    var id: String {
//        self.rawValue
//    }
//
//    case block, confirmBlock
// }

struct TabbarView: View {
    @StateObject private var viewModel: TabbarViewModel
    @State private var selectedTab: TabItem
//    @State private var selectedSheet: DtSheetType?
    @State private var dtConfDialogIsPresented: Bool = false
    @State private var blockingSheetIsPresented: Bool = false
    @State private var blockConfirmSheetIsPresented: Bool = false
    @State private var complainSheetIsPresented: Bool = false
    unowned let viewBuilder: NavigationViewBuilder

    init(viewBuilder: NavigationViewBuilder, selectedTab: TabItem = .dating) {
        self.viewBuilder = viewBuilder
        _viewModel = StateObject(wrappedValue: TabbarViewModel(selectedTab: selectedTab))
        _selectedTab = State(initialValue: selectedTab)
    }

    var body: some View {
        DtTabbar(tabsData: TabItem.allCases, selectedTab: $selectedTab, viewModel: viewModel) { item in
            createTabView(tab: item)
        }
        .dtConfirmationDialog(isPresented: $dtConfDialogIsPresented) {
            DtConfirmationDialogView(
                onBlock: {
                    dtConfDialogIsPresented = false
                    blockingSheetIsPresented = true
                },
                onComplain: {
                    dtConfDialogIsPresented = false
                    complainSheetIsPresented = true
                }
            )
        }
        .dtSheet(isPresented: $blockingSheetIsPresented) {
            BlockView(
                onConfirm: {
                    blockingSheetIsPresented = false
                    blockConfirmSheetIsPresented = true
                },
                onCancel: {
                    blockingSheetIsPresented = false
                }
            )
        }
        .dtSheet(isPresented: $blockConfirmSheetIsPresented) {
            ConfirmBlockView {
                blockConfirmSheetIsPresented = false
            }
        }
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating: viewBuilder.createDatingView(
            dtConfDialogIsPresented: $dtConfDialogIsPresented,
            complainSheetIsPresented: $complainSheetIsPresented
        )
        case .chat: viewBuilder.createChatView()
        case .menu: viewBuilder.createMenuView()
        }
    }
}
