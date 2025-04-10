//
//  TokenErrorResponse.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/8/25.
//


struct TokenErrorResponse: Decodable {
    let errorCode: String
    let message: String
}

struct TokenRefreshResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}