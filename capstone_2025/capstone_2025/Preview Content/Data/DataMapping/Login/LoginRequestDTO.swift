//
//  LoginRequestDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//


// MARK: - LoginRequestDTO

struct LoginRequestDTO: Encodable {
    let phoneNumber: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "userTel"
        case password
    }
}

