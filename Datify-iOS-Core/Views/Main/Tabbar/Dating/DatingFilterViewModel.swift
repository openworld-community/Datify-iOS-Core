//
//  DatingFilterViewModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 18.10.2023.
//

import SwiftUI

final class DatingFilterViewModel: ObservableObject {
    @Published var sex: Sex
    @Published var purpose: Set<Occupation>
    @Published var distance: Int
    @Published var minimumAge: Int
    @Published var maximumAge: Int
    @Binding private var filterDataService: FilterDataService

    init(userFilterModel: FilterModel, filterDataService: Binding<FilterDataService>) {
        self.sex = userFilterModel.sex
        self.purpose = userFilterModel.purpose
        self.distance = userFilterModel.distance
        self.minimumAge = userFilterModel.minimumAge
        self.maximumAge = userFilterModel.maximumAge
        self._filterDataService = filterDataService
    }

    func updateFilterModel() {
        filterDataService.updateFilterModel(updatedModel: FilterModel(
            sex: self.sex,
            purpose: self.purpose,
            minimumAge: self.minimumAge,
            maximumAge: self.maximumAge,
            distance: self.distance))
    }
}
