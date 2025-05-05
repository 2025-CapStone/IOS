//
//  ClubRepository.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/21/25.
//


import Foundation



protocol ClubRepository {
    func fetchMyClubs(userId: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void)
}
