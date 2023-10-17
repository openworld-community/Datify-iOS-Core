//
//  DatingFilterView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 16.10.2023.
//

import SwiftUI

struct DatingFilterView: View {
    @State var gender: String = "Female"
    @State var selectedOccupation: Set<Occupation> = [.findLove]
    @State var minAge: Int = 16
    @State var maxAge: Int = 99
    @State var distance: Int = 5
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Filters")
                        .dtTypo(.h3Medium, color: .textPrimary)
                    DtSegmentedPicker(selectedItem: $gender, items: ["Male", "Female", "All"]) { item in
                        Text(item).tag(item)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Search purpose:")
                        .dtTypo(.p2Medium, color: .primary)
                    VStack(spacing: 12) {
                        ForEach(Occupation.allCases, id: \.self) { occupation in
                            DtCheckBoxButton(
                                isSelected: selectedOccupation.contains(occupation),
                                title: occupation.title
                            ) {
                                if selectedOccupation.contains(occupation) {
                                    selectedOccupation.remove(occupation)
                                } else {
                                    selectedOccupation.insert(occupation)
                                }
                            }
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("Location:")
                        .dtTypo(.p2Medium, color: .primary)
                    DtButton(title: "Location", style: .secondary) {}
                }
                VStack(alignment: .leading) {
                    Text("Search distance:")
                        .dtTypo(.p2Medium, color: .primary)
                    DtDistanceSlider(selectedDistance: $distance)
                }
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
                        DtCustomPicker(selectedItem: $minAge, items: Array(16...99), height: 96) { age in
                            Text("\(age)").tag(age)
                        }
                        DtCustomPicker(selectedItem: $maxAge, items: Array(16...99), height: 96) { age in
                            Text("\(age)").tag(age)
                        }
                    }

                }

            }
            .padding(.horizontal)
        }
        DtButton(title: "Meow", style: .primary) {

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    func removeOccupation(element: Occupation) {
        if let index = selectedOccupation.firstIndex(where: {$0 == element}) {
            selectedOccupation.remove(at: index)
        }
    }
}

#Preview {
    DatingFilterView()
}
