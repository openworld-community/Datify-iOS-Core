////
////  DatingViewModel.swift
////  Datify-iOS-Core
////
////  Created by Ildar Khabibullin on 09.10.2023.
////
//
// import SwiftUI
// import Combine
//
// final class DatingViewModel: ObservableObject {
//    unowned let router: Router<AppRoute>
//    @Published var audioPlayerViewModels: [DatingModel.ID: DtAudioPlayerViewModel] = [:]
//
//    @Published var liked: Bool = false
//
//    @Published var showAlert = false
//    @Published var errorMessage: String?
//    @Published var users: [DatingModel] = DatingModel.defaultUsers
//    @Published var currentUserID: DatingModel.ID?
//
//    @Published var audioPlayerViewModel: DtAudioPlayerViewModel?
//
//    var error: Error? {
//        didSet {
//            if let error = error {
//                errorMessage = error.localizedDescription
//                showAlert = true
//            }
//        }
//    }
//
//    private var cancellables: Set<AnyCancellable> = []
//
//    init(router: Router<AppRoute>) {
//        self.router = router
//        setupBindings()
//        loadInitialData()
//
//    }
//
//    func setupBindings() {
//        $liked
//            .dropFirst()
//            .sink { [weak self] newValue in
//                guard let self = self, let currentUserId = self.currentUserID else { return }
//                if let userIndex = self.users.firstIndex(where: { $0.id == currentUserId }) {
//                    self.users[userIndex].liked = newValue
//                }
//            }
//            .store(in: &cancellables)
//
////        $currentUserID
////            .dropFirst()
////            .sink { [weak self] _ in
////                guard let self = self else { return }
////                print("currentUserID изменился. Останавливаю воспроизведение.")
////
////                self.audioPlayerViewModel?.stopPlayback()
////            }
////            .store(in: &cancellables)
//    }
//
//    func loadInitialData() {
//        currentUserID = users.first?.id
//
//        if let currentUserID = currentUserID,
//               let currentUser = users.first(where: {
//                   $0.id == currentUserID }) {
//            self.liked = currentUser.liked
//        }
//    }
// }
