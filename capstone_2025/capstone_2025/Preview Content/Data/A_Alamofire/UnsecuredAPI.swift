//
//  UnsecuredAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//

import SwiftUI
import Alamofire
final class UnsecuredAPI {
    static let shared = UnsecuredAPI()
    private init() {}

    private let baseURL = "https://api.on-club.co.kr"

    func signup(signupData: [String: Any]) async throws -> Data {
        let url = "\(baseURL)/api/user/join"

        return try await withCheckedThrowingContinuation { continuation in
            let request = AF.request(
                url,
                method: .post,
                parameters: signupData,
                encoding: JSONEncoding.default
            )

            request.cURLDescription { curl in
                print("[UnsecuredAPI] cURL Request:\n\(curl)")
            }

            request
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func login(loginData: [String: Any]) async throws -> Data {
        let url = "\(baseURL)/api/user/login"

        return try await withCheckedThrowingContinuation { continuation in
            let request = AF.request(
                url,
                method: .post,
                parameters: loginData,
                encoding: JSONEncoding.default,
                headers: ["Content-Type": "application/json"]
            )

            request.cURLDescription { curl in
                print("[UnsecuredAPI] cURL Request:\n\(curl)")
            }

            request
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
