// AppDIContainer.swift
// SwiftUI용으로 수정

import Foundation

final class AppDIContainer {

    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: "http://서버 IP")!
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
