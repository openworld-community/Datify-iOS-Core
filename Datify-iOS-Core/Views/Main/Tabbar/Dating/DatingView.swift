//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct DatingView: View {
    @StateObject private var viewModel: DatingViewModel
    @Binding private var isSheetPresented: Bool

    private var isSheeted: Bool {
        viewModel.dtConfDialogIsPresented ||
        viewModel.complainSheetIsPresented ||
        viewModel.confirmationSheetIsPresented ||
        viewModel.blockingSheetIsPresented
    }

    init(
        router: Router<AppRoute>,
        isSheetPresented: Binding<Bool>
    ) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
        _isSheetPresented = isSheetPresented
    }

    var body: some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: isSheeted) { _, newValue in
                    withAnimation {
                        isSheetPresented = newValue
                    }
                }
        } else {
            content
                .onChange(of: isSheeted, perform: { value in
                    withAnimation {
                        isSheetPresented = value
                    }
                })
        }
    }

    private var content: some View {
        VStack {
            HStack {
                DtLogoView()
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.2)) {
                        viewModel.filterSheetIsPresented.toggle()
                    }
                }
            label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill").resizableFit().frame(width: 24)
            }
                    Button {
                        viewModel.router.push(.notifications)
                    }
            label: {
                Image(systemName: "bell.fill").resizableFit().frame(width: 24)
            }

            }
            .padding(.horizontal)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(
            Image("exampleImage")
                .resizableFill()
                .ignoresSafeArea()
                .onLongPressGesture {
                    withAnimation {
                        viewModel.dtConfDialogIsPresented = true
                    }
                }
        )
        .blur(
            radius: viewModel.filterSheetIsPresented ? 10 : 0
        )
        .scaleEffect(
            viewModel.filterSheetIsPresented ?
            1.2 :
            isSheeted ? 1.1 : 1
        )
        .sheet(isPresented: $viewModel.filterSheetIsPresented) {
            if let userFilterModel = viewModel.userFilterModel {
                DatingFilterView(userFilterModel: userFilterModel,
                                 filterDataService: $viewModel.filterDataService,
                                 sheetIsDisplayed: $viewModel.filterSheetIsPresented)
                .presentationDetents([.fraction(0.99)])
            }

        }
        .sheet(isPresented: $viewModel.dtConfDialogIsPresented) {
            DtConfirmationDialogView(isPresented: $viewModel.dtConfDialogIsPresented) {
                viewModel.askToBlock()
            } onComplain: {
                viewModel.complain()
            }
            .readSize { newSize in
                viewModel.sheetSize = newSize
            }
            .presentationDetents([.height(viewModel.sheetSize.height)])
            .interactiveDismissDisabled()
            .presentationBackground(.clear)
        }
        .sheet(isPresented: $viewModel.complainSheetIsPresented) {
            ComplainView(
                isPresented: $viewModel.complainSheetIsPresented,
                onCompleted: {
                    viewModel.sendComplaint()
                }
            )
            .readSize { newSize in
                viewModel.sheetSize = newSize
            }
            .presentationDetents([.height(viewModel.sheetSize.height)])
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled()
        }
        .sheet(isPresented: $viewModel.confirmationSheetIsPresented) {
            ConfirmationView(
                confirmationType: viewModel.confirmationType) {
                    viewModel.finish()
                }
                .readSize { newSize in
                    viewModel.sheetSize = newSize
                }
                .presentationDetents([.height(viewModel.sheetSize.height)])
                .interactiveDismissDisabled()
                .presentationBackground(.clear)
        }
        .sheet(isPresented: $viewModel.blockingSheetIsPresented) {
            BlockView {
                viewModel.confirmBlock()
            } onCancel: {
                viewModel.cancelBlock()
            }
            .readSize { newSize in
                viewModel.sheetSize = newSize
            }
            .presentationDetents([.height(viewModel.sheetSize.height)])
            .interactiveDismissDisabled()
            .presentationBackground(.clear)
        }
    }
}

#Preview {
    DatingView(
        router: Router(), isSheetPresented: .constant(true)
    )
}
