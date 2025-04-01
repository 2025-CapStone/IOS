//
//  SignUpResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//
// MARK: - SingUpResponse DTO (Decodable)

import Foundation
struct SignUpResponseDTO: Decodable {
    let user: UserDTO
}

extension SignUpResponseDTO {
    struct UserDTO: Decodable {
        enum GenderDTO: String, Decodable {
            case male = "MALE"
            case female = "FEMALE"
        }

        private enum CodingKeys: String, CodingKey {
            case userName
            case gender
            case birthDate
            case region
            case userTel
            case password
            case career
        }

        let userName: String
        let gender: GenderDTO
        let birthDate: String
        let region: String
        let userTel: String
        let password: String
        let career: Int
    }
}

// MARK: - Mapping to Domain

extension SignUpResponseDTO.UserDTO {
    func toDomain() -> User {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return User(
            name: userName,
            gender: gender == .male ? .male : .female,
            birthDate: formatter.date(from: birthDate) ?? Date(),
            region: region,
            phoneNumber: userTel,
            password: password,
            career: career
        )
    }
}
