//
//  SignUpUseCase.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//

import Foundation

// MARK: - UseCase Protocol

protocol SignupUseCase {
    func execute(
        requestValue: SignupRequestValue,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable?
}

// MARK: - Request Value

struct SignupRequestValue {
    let user: User
}

// MARK: - UseCase Implementation

final class DefaultSignupUseCase: SignupUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(
        requestValue: SignupRequestValue,
        completion: @escaping (Result<User, Error>) -> Void
    ) -> Cancellable? {
        return userRepository.signup(requestValue.user, completion: completion)
    }
}
