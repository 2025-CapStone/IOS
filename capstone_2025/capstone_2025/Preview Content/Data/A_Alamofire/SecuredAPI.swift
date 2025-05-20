//
//  SecuredAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//

import Alamofire
import Foundation
final class SecuredAPI {
    static let shared = SecuredAPI()

    private let baseURL = "https://api.on-club.co.kr"

    private lazy var session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()

    private init() {}

    func request(
        path: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil
    ) async throws -> Data {
        let url = "\(baseURL)\(path)"

        return try await withCheckedThrowingContinuation { continuation in
            let request = session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default
            )

            request.cURLDescription { curl in
                print("[SecuredAPI] cURL Request:\n\(curl)")
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
extension SecuredAPI {
    func logout(refreshToken: String) async throws -> Data {
        let url = "\(baseURL)/api/user/logout"
        let headers: HTTPHeaders = [
            // ❗️ Bearer 없이 토큰만
            //"Authorization": "Bearer \(refreshToken)",
            "Authorization": refreshToken,
            "Content-Type": "application/json"
        ]

        return try await withCheckedThrowingContinuation { continuation in
            let request = AF.request(
                url,
                method: .post,
                parameters: nil, // ✅ body는 없음
                encoding: JSONEncoding.default,
                headers: headers
            )

            request.cURLDescription { curl in
                print("[SecuredAPI] cURL Logout Request:\n\(curl)")
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
    
    func requestWithQueryParams(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: Any]
    ) async throws -> Data {
        let url = "\(baseURL)\(path)"
        guard let accessToken = SessionStorage.shared.accessToken else {
            throw URLError(.userAuthenticationRequired)
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        return try await withCheckedThrowingContinuation { continuation in
            let request = session.request(
                url,
                method: method,
                parameters: queryParameters,
                encoding: URLEncoding(destination: .queryString), // ✅ 쿼리 파라미터로 명시
                headers: headers
            )

            request.cURLDescription { curl in
                print("[SecuredAPI] 🌀 cURL Query Request:\n\(curl)")
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
