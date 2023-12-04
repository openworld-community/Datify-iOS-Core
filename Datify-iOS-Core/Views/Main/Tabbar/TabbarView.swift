//
//  TabbarView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct TabbarView: View {
    @StateObject private var viewModel: TabbarViewModel
    @State private var selectedTab: TabItem
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
        .dtConfirmationDialog(isPresented: $viewModel.dtConfDialogIsPresented) {
            DtConfirmationDialogView(
                onBlock: {
                    viewModel.askToBlock()
                },
                onComplain: {
                    viewModel.complain()
                }
            )
        }
        .dtSheet(isPresented: $viewModel.blockingSheetIsPresented) {
            BlockView(
                onConfirm: {
                    viewModel.confirmBock()
                },
                onCancel: {
                    viewModel.cancel(for: &viewModel.blockingSheetIsPresented)
                }
            )
        }
        .dtSheet(isPresented: $viewModel.blockConfirmSheetIsPresented) {
            ConfirmBlockView {
                viewModel.cancel(for: &viewModel.blockConfirmSheetIsPresented)
            }
        }
    }

    @ViewBuilder
    func createTabView(tab: TabItem) -> some View {
        switch tab {
        case .dating: viewBuilder.createDatingView(
            dtConfDialogIsPresented: $viewModel.dtConfDialogIsPresented,
            complainSheetIsPresented: $viewModel.complainSheetIsPresented
        )
        case .chat: viewBuilder.createChatView()
        case .menu: viewBuilder.createMenuView()
        }
    }
}
