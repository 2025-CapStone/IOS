

import Foundation
import Alamofire

final class ClubListViewModel: ObservableObject {
    @Published var clubs: [ClubResponseDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    //@Published var Joinedclubs: [ClubResponseDTO] = []
    init(){print("ClubListViewModel Created || \(Date())")}

    func fetchAllClubs() {
        guard let accessToken = SessionStorage.shared.accessToken else {
            print("[ClubListViewModel] ❌ 토큰 없음 - fetchClubs() 실패")
            self.errorMessage = "로그인이 필요합니다."
            return
        }

        isLoading = true
        errorMessage = nil

        ClubAPI.fetchAllClubs(accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let clubs):
                    self?.clubs = clubs
                    print("[ClubListViewModel] ✅ 모든 clubs: \(clubs.map { $0.clubName })")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("[ClubListViewModel] ❌ error: \(error)")
                }
            }
        }
    }

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
                    //self?.clubs = clubs
                    AppState.shared.user!.joinedClub = clubs
                    
                    print("[ClubListViewModel] ✅ clubs: \(clubs.map { $0.clubName })")
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("[ClubListViewModel] ❌ error: \(error)")
                }
            }
        }
    }

    
    func findClubNameById(id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard let accessToken = SessionStorage.shared.accessToken else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 없습니다."])))
            return
        }
        guard let user = AppState.shared.user,
              let accessToken = SessionStorage.shared.accessToken,
              let userId = Int(user.id)else {
            print("[ClubListViewModel] 유저 또는 토큰 없음 - fetchClubs() 실패")
            self.errorMessage = "로그인이 필요합니다."
            return
        }
        ClubAPI.findClubById(clubId: id, accessToken: accessToken) { result in
            switch result {
            case .success(let club):
                completion(.success(club.clubName))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func joinClub(clubId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard
            let user = AppState.shared.user,
            let accessToken = SessionStorage.shared.accessToken,
            let userId = Int(user.id)
        else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인이 필요합니다."])))
            return
        }

        MembershipAPI.joinClub(
            userId: userId,
            clubId: clubId,
            accessToken: accessToken,
            completion: completion
        )
    }

}
