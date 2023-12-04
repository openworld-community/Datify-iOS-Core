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
                        viewModel.filterSheetIsPresented.toggle()
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
        .navigationBarBackButtonHidden()
        .background(
            Image("exampleImage")
                .resizableFill()
                .ignoresSafeArea()
                .onLongPressGesture {
                    dtConfDialogIsPresented = true
                }
        )
        .blur(radius: viewModel.filterSheetIsPresented ? 10 : 0)
        .scaleEffect(viewModel.filterSheetIsPresented ? 1.2 : 1)
        .sheet(isPresented: $viewModel.filterSheetIsPresented) {
            if let userFilterModel = viewModel.userFilterModel {
                DatingFilterView(userFilterModel: userFilterModel,
                                 filterDataService: $viewModel.filterDataService,
                                 sheetIsDisplayed: $viewModel.filterSheetIsPresented)
                .presentationDetents([.fraction(0.99)])
            }

        }
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
