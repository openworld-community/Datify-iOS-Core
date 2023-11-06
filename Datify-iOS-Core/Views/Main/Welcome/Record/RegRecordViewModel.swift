//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.11.2023.
//

import Foundation
import SwiftUI

class RegRecordViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var powerGraphModel: PowerGraphModel

    init(router: Router<AppRoute>) {
        self.router = router
        powerGraphModel = PowerGraphModel(widthElement: 3, heightGraph: 160, wightGraph: Int(UIScreen.main.bounds.width), distanceElements: 2, deleteDuration: 1.0, recordingDuration: 15)
    }
}
