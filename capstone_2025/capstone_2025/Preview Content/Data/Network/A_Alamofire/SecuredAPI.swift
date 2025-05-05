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

    private let baseURL = "http://43.201.191.12:8080"

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
