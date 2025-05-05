import Foundation

final class DefaultClubRepository: ClubRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

    func fetchMyClubs(userId: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void) {
        let endpoint = APIEndpoints.getClubsByUserId(userId: userId)
        _ = dataTransferService.request(with: endpoint) { result in
            
            print(result)
            switch result {
          
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
