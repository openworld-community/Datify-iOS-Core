//
//  DatingViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import Foundation
import Combine

final class DatingViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    private var cancellables = Set<AnyCancellable>()
    var filterDataService = FilterDataService()
    @Published var userFilterModel: FilterModel?
    @Published var filterSheetIsPresented: Bool = false
    @Published var dtConfDialogIsPresented: Bool = false
    @Published var complainSheetIsPresented: Bool = false
    @Published var sheetSize: CGSize = .zero

    init(
        router: Router<AppRoute>
    ) {
        self.router = router
        self.addSubscribers()
    }

    func addSubscribers() {
        filterDataService.$userFilterModel
            .sink { [weak self] fetchedFilterModel in
                self?.userFilterModel = fetchedFilterModel
            }
            .store(in: &cancellables)
    }
}
