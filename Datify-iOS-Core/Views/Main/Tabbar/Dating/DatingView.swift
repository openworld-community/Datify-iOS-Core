//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct DatingView: View {
    @StateObject private var viewModel: DatingViewModel
    @Binding var dtConfDialogIsPresented: Bool
    @Binding var complainSheetIsPresented: Bool

    init(
        router: Router<AppRoute>,
        dtConfDialogIsPresented: Binding<Bool>,
        complainSheetIsPresented: Binding<Bool>
    ) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
        _dtConfDialogIsPresented = dtConfDialogIsPresented
        _complainSheetIsPresented = complainSheetIsPresented
    }

    var body: some View {
        VStack {
            HStack {
                DtLogoView()
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.2)) {
                        viewModel.sheetIsPresented.toggle()
                    }
                }
            label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill").resizableFit().frame(width: 24)
            }
                Button {}
            label: {
                Image(systemName: "bell.fill").resizableFit().frame(width: 24)
            }

            }
            .padding(.horizontal)
            Spacer()
        }
        .background(
            Image("exampleImage")
                .resizableFill()
                .ignoresSafeArea()
                .onLongPressGesture {
//                    viewModel.blockingMenuIsPresented.toggle()
                    dtConfDialogIsPresented = true
                }
        )
        .blur(radius: viewModel.sheetIsPresented ? 10 : 0)
        .scaleEffect(viewModel.sheetIsPresented ? 1.2 : 1)
        .sheet(isPresented: $viewModel.sheetIsPresented) {
            if let userFilterModel = viewModel.userFilterModel {
                DatingFilterView(userFilterModel: userFilterModel,
                                 filterDataService: $viewModel.filterDataService,
                                 sheetIsDisplayed: $viewModel.sheetIsPresented)
                .presentationDetents([.fraction(0.99)])
            }

        }
//        .dtConfirmationDialog(
//            isPresented: $viewModel.blockingMenuIsPresented
//        ) {
//            confirmationDialogView()
//        }
//        .dtSheet(isPresented: $viewModel.blockingSheetIsPresented) {
//            BlockView(
//                onConfirm: {
//                    viewModel.confirmBlock()
//                },
//                onCancel: {
//                    viewModel.blockingSheetIsPresented = false
//                }
//            )
//        }
//        .dtSheet(isPresented: $viewModel.blockConfirmSheetIsPresented) {
//            ConfirmBlockView {
//                viewModel.blockConfirmSheetIsPresented = false
//            }
//        }
        .sheet(isPresented: $complainSheetIsPresented) {
            Text("Complain sheet")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    DatingView(
        router: Router(),
        dtConfDialogIsPresented: .constant(true),
        complainSheetIsPresented: .constant(true)
    )
}
