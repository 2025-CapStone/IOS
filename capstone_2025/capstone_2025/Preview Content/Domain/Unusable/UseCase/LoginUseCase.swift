import Foundation

protocol LoginUseCase {
    func execute(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) -> Cancellable?
}

final class DefaultLoginUseCase: LoginUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) -> Cancellable? {
        return userRepository.login(phoneNumber: phoneNumber, password: password, completion: completion)
    }
}
