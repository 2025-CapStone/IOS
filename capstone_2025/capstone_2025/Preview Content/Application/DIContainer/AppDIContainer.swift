//
//  AppDIContainer.swift
//  capstone_2025
//
//  Created by ㅇㅇㅇ on 2025-04-22.
//

import Foundation

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    private init() {}
    
    // ✅ 재시도 네트워크 서비스 (accessToken 만료 대응)
    private(set) var retryingNetworkService: RetryingNetworkService!

    // ✅ 로그인 여부에 따라 네트워크를 선택하도록 구성 (확장 가능)
    var apiDataTransferService: DataTransferService {
        return authorizedDataTransferService
    }

    // ✅ 기본 baseURL 설정
    private var baseURL: URL {
        return URL(string: "http://43.201.191.12:8080")!
    }

    // ✅ 인증된 사용자를 위한 네트워크 설정 (accessToken 포함)
    private lazy var authorizedDataTransferService: DataTransferService = {
        let config = AuthorizedNetworkConfig(baseURL: baseURL)
        let baseNetwork = DefaultNetworkService(config: config)
        let retrying = RetryingNetworkService(wrapping: baseNetwork)
        self.retryingNetworkService = retrying
        return DefaultDataTransferService(with: retrying)
    }()

    // MARK: - Signup DI
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel()
    }

    func makeSignupUseCase() -> SignupUseCase {
        DefaultSignupUseCase(userRepository: makeUserRepository())
    }

    func makeUserRepository() -> UserRepository {
        DefaultUserRepository(dataTransferService: apiDataTransferService)
    }

    // MARK: - Login DI
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel()
    }

    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(userRepository: makeUserRepository())
    }

    // MARK: - Club List DI
    func makeClubListViewModel() -> ClubListViewModel {
        ClubListViewModel()
    }

    func makeClubUseCase() -> ClubUseCase {
        FetchClubListUseCase(repository: makeClubRepository())
    }

    func makeClubRepository() -> ClubRepository {
        return DefaultClubRepository(dataTransferService: apiDataTransferService)
    }
    
    
 

    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel()
        //vm.setClubId(clubId)
       // return vm
    }

}


//// AppDIContainer.swift
//
////기존의 ApiDataNetworkConfig 대신, AuthorizedNetworkConfig를 사용하도록 DIContainer 수정.
////모든 API 요청 시 Authorization: Bearer <token> 헤더 자동 추가.
//import Foundation
//
//final class AppDIContainer {
//    
//    static let shared = AppDIContainer()
//    private init() {}
//    private(set) var retryingNetworkService: RetryingNetworkService!
//
//    
//    // MARK: - Network
////    lazy var apiDataTransferService: DataTransferService = {
////        let config = /*ApiDataNetworkConfig*/AuthorizedNetworkConfig(
////            baseURL: URL(string: "https://mock.api")!
////        )
////        let apiDataNetwork = DefaultNetworkService(config: config)
////        return DefaultDataTransferService(with: apiDataNetwork)
////    }()
//    lazy var apiDataTransferService: DataTransferService = {
//        let config = AuthorizedNetworkConfig(
//            baseURL: URL(string: "http://43.201.191.12:8080")!
//        )
//        let baseNetwork = DefaultNetworkService(config: config)
//        let retrying = RetryingNetworkService(wrapping: baseNetwork)
//        self.retryingNetworkService = retrying
//        return DefaultDataTransferService(with: retrying)
//    }()
//    
//    
//
//    // MARK: - Signup DI
//    func makeSignupViewModel() -> SignupViewModel {
//        SignupViewModel(signupUseCase: makeSignupUseCase())
//    }
//
//    func makeSignupUseCase() -> SignupUseCase {
//        DefaultSignupUseCase(userRepository: makeUserRepository())
//    }
//
//    func makeUserRepository() -> UserRepository {
//        DefaultUserRepository(
//            dataTransferService: apiDataTransferService
//        )
//    }
//
//    // MARK: - Login DI
//    func makeLoginViewModel() -> LoginViewModel {
//        LoginViewModel(loginUseCase: makeLoginUseCase())
//    }
//
//    func makeLoginUseCase() -> LoginUseCase {
//        DefaultLoginUseCase(userRepository: makeUserRepository())
//    }
//    
//    // MARK: - Club
//     func makeClubListViewModel() -> ClubListViewModel {
//         ClubListViewModel(useCase: makeClubUseCase())
//     }
//
//     func makeClubUseCase() -> ClubUseCase {
//         FetchClubListUseCase(repository: makeClubRepository())
//     }
//
//    func makeClubRepository() -> ClubRepository {
//        return DefaultClubRepository(dataTransferService: DataTransferService)
//    }
// }
//
//
