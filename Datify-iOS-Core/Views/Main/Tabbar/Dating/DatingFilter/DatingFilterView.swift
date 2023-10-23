//
//  DatingFilterView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 16.10.2023.
//

import SwiftUI

struct DatingFilterView: View {
    @StateObject private var viewModel: DatingFilterViewModel
    @Binding var sheetIsDisplayed: Bool

    init(userFilterModel: FilterModel, filterDataService: Binding<FilterDataService>, sheetIsDisplayed: Binding<Bool>) {
        _viewModel = StateObject(
            wrappedValue:
                DatingFilterViewModel(userFilterModel: userFilterModel,
                                      filterDataService: filterDataService)
        )
        self._sheetIsDisplayed = sheetIsDisplayed
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    sexFilter
                    purposeFilter
                    locationFilter
                    distanceFilter
                    ageFilter
                }
                .padding(.horizontal)
            }
            .toolbar {
                toolbarSection
            }
            DtButton(title: "Apply changes".localize(), style: .primary) {
                viewModel.updateFilterModel()
                animatedDismiss()
            }
            .disabled(viewModel.purpose.isEmpty)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .interactiveDismissDisabled(true)
        }
    }
}

private extension DatingFilterView {
    private func animatedDismiss() {
        withAnimation(.linear(duration: 0.3)) {
            sheetIsDisplayed.toggle()
        }
    }

    private var toolbarSection: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarTrailing) {
                DtXMarkButton {
                    animatedDismiss()
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("Filters")
                    .dtTypo(.h3Medium, color: .textPrimary)
            }
        }

    }
    private var sexFilter: some View {
        VStack(alignment: .leading) {
            DtSegmentedPicker(selectedItem: $viewModel.sex, items: Sex.allCases) { item in
                Text(item.title()).tag(item)
            }
        }
    }
    private var purposeFilter: some View {
        VStack(alignment: .leading) {
            Text("Search purpose:")
                .dtTypo(.p2Medium, color: .primary)
            VStack(spacing: 12) {
                ForEach(Occupation.allCases, id: \.self) { occupation in
                    DtCheckBoxButton(
                        isSelected: viewModel.purpose.contains(occupation),
                        title: occupation.title
                    ) {
                        if viewModel.purpose.contains(occupation) {
                            viewModel.purpose.remove(occupation)
                        } else {
                            viewModel.purpose.insert(occupation)
                        }
                    }
                }
            }
        }
    }
    private var locationFilter: some View {
        VStack(alignment: .leading) {
            Text("Location:")
                .dtTypo(.p2Medium, color: .primary)
            // TODO: Location section
            // TEMPORARY PLACEHOLDER
            DtButton(title: "Location", style: .secondary) {}
        }
    }
    private var distanceFilter: some View {
        VStack(alignment: .leading) {
            Text("Search distance:")
                .dtTypo(.p2Medium, color: .primary)
            DtStepSliderSegment(selectedItem: $viewModel.distance,
                                items: Distances.allCases,
                                labels: Distances.allLabels)
        }
    }
    private var ageFilter: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Minimum age:")
                    .dtTypo(.p2Medium, color: .primary)
                Spacer()
                Text("Maximum age:")
                    .dtTypo(.p2Medium, color: .primary)
                    .offset(x: 6)
                Spacer()
            }
            HStack {
                DtCustomPicker(selectedItem: $viewModel.minimumAge,
                               items: Array(16...viewModel.maximumAge),
                               height: 96) { age in
                    Text("\(age)").tag(age)
                }
                DtCustomPicker(selectedItem: $viewModel.maximumAge,
                               items: Array(viewModel.minimumAge...99),
                               height: 96) { age in
                    Text("\(age)").tag(age)
                }
            }
        }
    }
}

#Preview {
    DatingView(router: Router())
}
