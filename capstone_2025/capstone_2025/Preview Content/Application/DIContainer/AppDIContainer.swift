// AppDIContainer.swift


import Foundation

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    private init() {}
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: "https://mock.api")!
        )
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
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
