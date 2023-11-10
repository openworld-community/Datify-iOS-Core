//
//  RegOccupationView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 19.09.2023.
//

import SwiftUI

enum Occupation: CaseIterable, Equatable, Codable {

    case goOnDates, communication, findLove

    var title: String {
        switch self {
        case .goOnDates:
            return "Go on dates".localize()
        case .findLove:
            return "Find the love of my life".localize()
        case .communication:
            return "Just chat".localize()
        }
    }
}

struct RegOccupationView: View {
    @State private var selectedOccupation: Occupation?
    unowned let router: Router<AppRoute>

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            titleSegment
            selectorSegment
            Spacer()
            HStack(spacing: 8) {
                DtBackButton {
                    router.pop()
                }
                DtButton(title: "Proceed".localize(), style: .main) {
                    // TODO: - Proceed button action
                    router.push(.registrationPassword)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .padding(.horizontal)
        .padding(.bottom)

    }
}

struct RegOccupationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegOccupationView(router: Router())
        }
    }
}

private extension RegOccupationView {
    var titleSegment: some View {
        VStack(spacing: 8) {
            Text("What do you want to do?")
                .dtTypo(.h3Regular, color: .textPrimary)
            Text("Select the search goal you are interested in")
                .dtTypo(.p3Regular, color: .textSecondary)
        }
    }
    var selectorSegment: some View {
        VStack(spacing: 12) {
            ForEach(Occupation.allCases, id: \.self) { occupation in
                DtSelectorButton(
                    isSelected: selectedOccupation == occupation,
                    title: occupation.title
                ) {
                    selectedOccupation = occupation
                }
            }
        }
    }
}
