//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct DatingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DatingViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
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
                    viewModel.blockingMenuIsPresented.toggle()
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
        .dtConfirmationDialog(
            isPresented: $viewModel.blockingMenuIsPresented
        ) {
            Button {
                viewModel.blockingMenuIsPresented = false
                viewModel.blockingSheetIsPresented = true
            } label: {
                Text("Block")
                    .frame(maxWidth: .infinity)
            }
            .dtTypo(.p2Medium, color: .textPrimary)

            Divider().padding(.vertical, 4)

            Button {
                viewModel.blockingMenuIsPresented = false
                viewModel.complainSheetIsPresented = true
            } label: {
                Text("Complain")
                    .frame(maxWidth: .infinity)
            }
            .dtTypo(.p2Medium, color: .accentsPink)
        }
        .sheet(isPresented: $viewModel.blockingSheetIsPresented) {
            Text("Blocking sheet")
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $viewModel.complainSheetIsPresented) {
            Text("Complain sheet")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    DatingView(router: Router())
}
