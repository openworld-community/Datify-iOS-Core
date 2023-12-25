//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct DatingView: View {
    @StateObject private var viewModel: DatingViewModel
    @Binding private var dtConfDialogIsPresented: Bool
    @Binding private var complainSheetIsPresented: Bool
    @Binding private var confirmationSheetIsPresented: Bool
    @Binding private var confirmationType: ConfirmationView.ConfirmationType

    init(
        router: Router<AppRoute>,
        dtConfDialogIsPresented: Binding<Bool>,
        complainSheetIsPresented: Binding<Bool>,
        confirmationSheetIsPresented: Binding<Bool>,
        confirmationType: Binding<ConfirmationView.ConfirmationType>
    ) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
        _dtConfDialogIsPresented = dtConfDialogIsPresented
        _complainSheetIsPresented = complainSheetIsPresented
        _confirmationSheetIsPresented = confirmationSheetIsPresented
        _confirmationType = confirmationType
    }

    var body: some View {
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
                    dtConfDialogIsPresented = true
                }
        )
        .blur(
            radius: viewModel.filterSheetIsPresented ||
                    complainSheetIsPresented ? 10 : 0
        )
        .scaleEffect(
            viewModel.filterSheetIsPresented ||
            complainSheetIsPresented ||
            dtConfDialogIsPresented ?
            1.2 : 1
        )
        .sheet(isPresented: $viewModel.filterSheetIsPresented) {
            if let userFilterModel = viewModel.userFilterModel {
                DatingFilterView(userFilterModel: userFilterModel,
                                 filterDataService: $viewModel.filterDataService,
                                 sheetIsDisplayed: $viewModel.filterSheetIsPresented)
                .presentationDetents([.fraction(0.99)])
            }

        }
        .sheet(isPresented: $complainSheetIsPresented) {
            ComplainView(
                isPresented: $complainSheetIsPresented,
                onCompleted: {
                    confirmationType = .complain
                    confirmationSheetIsPresented = true
                }
            )
            .readSize { newSize in
                viewModel.sheetSize = newSize
            }
            .presentationDetents([.height(viewModel.sheetSize.height)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    DatingView(
        router: Router(),
        dtConfDialogIsPresented: .constant(false),
        complainSheetIsPresented: .constant(true),
        confirmationSheetIsPresented: .constant(false),
        confirmationType: .constant(.complain)
    )
}
