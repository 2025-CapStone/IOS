//
//  SessionStorage.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//


import Foundation

final class SessionStorage {
    static let shared = SessionStorage()

    private init() {}

    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }

    var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: "refreshToken") }
        set { UserDefaults.standard.set(newValue, forKey: "refreshToken") }
    }
}
