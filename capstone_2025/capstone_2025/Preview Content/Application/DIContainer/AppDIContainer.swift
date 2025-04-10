// AppDIContainer.swift

//기존의 ApiDataNetworkConfig 대신, AuthorizedNetworkConfig를 사용하도록 DIContainer 수정.
//모든 API 요청 시 Authorization: Bearer <token> 헤더 자동 추가.
import Foundation

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    private init() {}
    private(set) var retryingNetworkService: RetryingNetworkService!

    
    // MARK: - Network
//    lazy var apiDataTransferService: DataTransferService = {
//        let config = /*ApiDataNetworkConfig*/AuthorizedNetworkConfig(
//            baseURL: URL(string: "https://mock.api")!
//        )
//        let apiDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: apiDataNetwork)
//    }()
    lazy var apiDataTransferService: DataTransferService = {
        let config = AuthorizedNetworkConfig(
            baseURL: URL(string: "http://43.201.191.12:8080")!
        )
        let baseNetwork = DefaultNetworkService(config: config)
        let retrying = RetryingNetworkService(wrapping: baseNetwork)
        self.retryingNetworkService = retrying
        return DefaultDataTransferService(with: retrying)
    }()
    
    

    // MARK: - Signup DI
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(signupUseCase: makeSignupUseCase())
    }

    func makeSignupUseCase() -> SignupUseCase {
        DefaultSignupUseCase(userRepository: makeUserRepository())
    }

    func makeUserRepository() -> UserRepository {
        DefaultUserRepository(
            dataTransferService: apiDataTransferService
        )
    }

    // MARK: - Login DI
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase())
    }

    func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(userRepository: makeUserRepository())
    }
    
    
}

