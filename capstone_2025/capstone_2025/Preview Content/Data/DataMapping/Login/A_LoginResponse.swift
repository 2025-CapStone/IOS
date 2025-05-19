//
//  LoginResponse.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//


struct LoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
}
