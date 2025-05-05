//
//import Foundation
//
//final class ClubListViewModel: ObservableObject {
//    @Published var clubs: [ClubResponseDTO] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//
//    private let useCase: ClubUseCase
//
//    init(useCase: ClubUseCase) {
//        self.useCase = useCase
//    }
//
//    func fetchMyClubs(userId: String) {
//        isLoading = true
//        errorMessage = nil
//
//        useCase.fetchMyClubs(userId: userId) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let clubs):
//                    self?.clubs = clubs
//                    print("[ClubListViewModel] clubs: \(clubs.map { $0.clubName })")
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    print("[ClubListViewModel] error: \(error)")
//                }
//            }
//        }
//    }
//}



//import Foundation
//import Combine
//
//final class ClubListViewModel: ObservableObject {
//    @Published var clubs: [ClubResponseDTO] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//
//    private let useCase: ClubUseCase
//
//    init(useCase: ClubUseCase) {
//        self.useCase = useCase
//    }
//
//    func fetchClubs() {
//        guard let userId = AppState.shared.user?.id else {
//            self.errorMessage = "사용자 정보가 없습니다."
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//
//        useCase.fetchMyClubs(userId: userId) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let clubs):
//                    self?.clubs = clubs
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    self?.clubs = []
//                }
//            }
//        }
//    }
//}
