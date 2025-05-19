//
//  TokenStorage.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/6/25.
//


final class TokenStorage {
    static let shared = TokenStorage()
    private init() {}

    var accessToken: String?
    var refreshToken: String?
}