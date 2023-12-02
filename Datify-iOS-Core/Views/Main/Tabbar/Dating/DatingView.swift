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
            confirmationDialogView()
        }
        .dtSheet(isPresented: $viewModel.blockingSheetIsPresented) {
            blockView
        }
        .sheet(isPresented: $viewModel.complainSheetIsPresented) {
            Text("Complain sheet")
                .presentationDetents([.medium])
        }
        .dtSheet(isPresented: $viewModel.blockConfirmSheetIsPresented) {
            confirmBlockView
        }
    }
}

private extension DatingView {
    func confirmationDialogView() -> some View {
        Group {
            Button {
                viewModel.blockingMenuIsPresented = false
                viewModel.blockingSheetIsPresented = true
            } label: {
                Text("Block")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .dtTypo(.p2Medium, color: .textPrimary)

            Divider()

            Button {
                viewModel.blockingMenuIsPresented = false
                viewModel.complainSheetIsPresented = true
            } label: {
                Text("Complain")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            .dtTypo(.p2Medium, color: .accentsPink)
        }
    }

    var blockView: some View {
        VStack(spacing: 16) {
            ZStack {
                Color.accentsPink
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.iconsPrimary)
                    .colorScheme(.dark)

            }
            .frame(width: 48, height: 48)
            .clipped()
            .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("Do you want to block this user?")
                        .dtTypo(.h3Medium, color: .textPrimary)
                        .multilineTextAlignment(.center)
                    Text("The user will be blocked and will no longer be able to find your profile on Datify")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 8) {
                    DtButton(
                        title: "Yes, block",
                        style: .main) {
                            viewModel.confirmBlock()
                        }
                    Button {
                        viewModel.blockingSheetIsPresented = false
                    } label: {
                        Text("No, cancel")
                            .dtTypo(.p2Medium, color: .textPrimary)
                            .frame(maxWidth: .infinity, maxHeight: AppConstants.Visual.buttonHeight)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.backgroundSecondary)
                            )
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                }
            }
        }
        .padding(
            EdgeInsets(
                top: 32,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
    }

    var confirmBlockView: some View {
        ZStack(alignment: .top) {
            Image("flowerIcon")
                .shadow(color: Color(hex: 0x14282A52).opacity(0.2), radius: 8, y: 2)

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("User successfully blocked")
                        .dtTypo(.h3Medium, color: .textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Thanks for the appeal, now this user won't bother you anymore").dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }

                DtButton(
                    title: "Got it",
                    style: .main) {
                        viewModel.blockConfirmSheetIsPresented = false
                    }
            }
            .padding(.top, 90)
        }
        .padding(
            EdgeInsets(
                top: 20,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )
    }
}

#Preview {
    DatingView(router: Router())
}
