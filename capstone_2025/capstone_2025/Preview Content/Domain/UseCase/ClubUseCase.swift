//
//  ClubUseCase.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/22/25.
//


import Foundation

protocol ClubUseCase {
    func fetchMyClubs(userId: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void)
}

final class FetchClubListUseCase: ClubUseCase {
    private let repository: ClubRepository

    init(repository: ClubRepository) {
        self.repository = repository
    }

    func fetchMyClubs(userId: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void) {
        
        repository.fetchMyClubs(userId: userId, completion: completion)
    }
}
