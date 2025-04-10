//
//  UserRepository.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//

// MARK: - UserRepository


protocol UserRepository {
    func signup(_ user: SignupUser, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
    func login(phoneNumber: String, password: String, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) -> Cancellable?

}
