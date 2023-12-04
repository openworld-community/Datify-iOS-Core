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
    @State var sheetIsPresented: Bool = false

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            // Dating main view

            VStack {
                HStack {
                    DtLogoView()
                    Spacer()
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            sheetIsPresented.toggle()
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

        }
        .blur(radius: sheetIsPresented ? 10 : 0)
        .scaleEffect(sheetIsPresented ? 1.2 : 1)
        .sheet(isPresented: $sheetIsPresented) {
            if let userFilterModel = viewModel.userFilterModel {
                DatingFilterView(userFilterModel: userFilterModel,
                                 filterDataService: $viewModel.filterDataService,
                                 sheetIsDisplayed: $sheetIsPresented)
                .presentationDetents([.fraction(0.99)])
            }

        }
    }
}

#Preview {
    DatingView(router: Router())
}
