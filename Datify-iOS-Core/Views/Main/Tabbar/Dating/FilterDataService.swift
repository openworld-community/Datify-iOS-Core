//
//  DatingFilterService.swift
//  Datify-iOS-Core
//
//  Created by Илья on 18.10.2023.
//

import Foundation

// Временно сделал хранение параметров фильтра в UserDefaults,
// потом надо решить где будет храниться, в UserModel и подтягивать с бэка
// или и так устраивает / CoreData / Swift Data / ...

final class FilterDataService {
    private let filterKey = "filter_specifications"
    @Published var userFilterModel: FilterModel = FilterModel(
        sex: .male,
        purpose: [.communication],
        minimumAge: 16,
        maximumAge: 99,
        distance: 5
    )

    init() {
        // TODO: Func to fetch FilterModel from UserModel
        getData()
    }

    func updateFilterModel(updatedModel: FilterModel) {
        // TODO: Func to update FilterModel in UserModel
        userFilterModel = updatedModel
        saveData()
    }

    func saveData() {
        if let encodedData = try? JSONEncoder().encode(userFilterModel) {
            UserDefaults.standard.setValue(encodedData, forKey: filterKey)
        }
        getData()
    }

    private func getData() {
        guard let data = UserDefaults.standard.data(forKey: filterKey) else { return }
        if let filterModel = try? JSONDecoder().decode(FilterModel.self, from: data) {
            userFilterModel = filterModel
        }
    }
}
