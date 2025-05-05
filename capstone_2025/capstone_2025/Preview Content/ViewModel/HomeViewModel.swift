

import Foundation
import Alamofire

final class ClubListViewModel: ObservableObject {
    @Published var clubs: [ClubResponseDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchClubs() {
        guard let user = AppState.shared.user,
              let accessToken = SessionStorage.shared.accessToken,
              let userId = Int(user.id)else {
            print("[ClubListViewModel] 유저 또는 토큰 없음 - fetchClubs() 실패")
            self.errorMessage = "로그인이 필요합니다."
            return
        }

        isLoading = true
        errorMessage = nil

        ClubAPI.fetchJoinedClubs(userId: userId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clubs):
                    self?.clubs = clubs
                    print("[ClubListViewModel] ✅ clubs: \(clubs.map { $0.clubName })")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("[ClubListViewModel] ❌ error: \(error)")
                }
            }
        }
    }
}
