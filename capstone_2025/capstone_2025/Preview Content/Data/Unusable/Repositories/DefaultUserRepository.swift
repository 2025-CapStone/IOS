import Foundation

// MARK: - UserRepository 구현체
final class DefaultUserRepository: UserRepository {

    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }

    func signup(_ user: SignupUser, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        let requestDTO = SignUpRequestDTO(user)
        let task = RepositoryTask()

        let endpoint = APIEndpoints.signup(requestDTO)
        task.networkTask = dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }

        return task
    }


}

extension DefaultUserRepository {

    // ✅ 수정: Result<User, Error> → Result<LoginResponseDTO, Error>
    func login(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) -> Cancellable? {
        let requestDTO = LoginRequestDTO(phoneNumber: phoneNumber, password: password)
        let endpoint = APIEndpoints.login(requestDTO)
        let task = RepositoryTask()

        task.networkTask = dataTransferService.request(with: endpoint, on: backgroundQueue) { result in
            switch result {
            case .success(let dto):
                completion(.success(dto)) // ✅ dto 그대로 전달
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}


//// DefaultUserRepository.swift
//// capstone_2025
//
//import Foundation
//
//// MARK: - UserRepository 구현체
//final class DefaultUserRepository: UserRepository {
//
//    private let dataTransferService: DataTransferService
//    private let backgroundQueue: DataTransferDispatchQueue
//
//    init(
//        dataTransferService: DataTransferService,
//        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
//    ) {
//        self.dataTransferService = dataTransferService
//        self.backgroundQueue = backgroundQueue
//    }
//
//    func signup(_ user: User, completion: @escaping (Result<User, Error>) -> Void) -> Cancellable? {
//        let requestDTO = SignUpRequestDTO(user)
//        let task = RepositoryTask()
//
//        let endpoint = APIEndpoints.signup(requestDTO)
//        task.networkTask = dataTransferService.request(
//            with: endpoint,
//            on: backgroundQueue
//        ) { result in
//            switch result {
//            case .success(let responseDTO):
//                let user = responseDTO.user.toDomain()
//                completion(.success(user))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//
//        return task
//    }
//
//    
//}
//
//extension DefaultUserRepository {
//    func login(phoneNumber: String, password: String, completion: @escaping (Result<User, Error>) -> Void) -> Cancellable? {
//        let requestDTO = LoginRequestDTO(phoneNumber: phoneNumber, password: password)
//        let endpoint = APIEndpoints.login(requestDTO)
//        let task = RepositoryTask()
//
//        task.networkTask = dataTransferService.request(with: endpoint, on: backgroundQueue) { result in
//            switch result {
//            case .success(let dto):
//                completion(.success(dto.user.toDomain()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        return task
//    }
//}
//
