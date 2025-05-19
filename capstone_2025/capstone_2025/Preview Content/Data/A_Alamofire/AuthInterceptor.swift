//
//  AuthInterceptor.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//


import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {
    
    private let retryLimit = 1
    private var retryCount = 0
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        if let accessToken = SessionStorage.shared.accessToken {
            adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(adaptedRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            retryCount < retryLimit
        else {
            return completion(.doNotRetry)
        }
        
        refreshAccessToken { success in
            if success {
                self.retryCount += 1
                completion(.retry)
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = SessionStorage.shared.refreshToken else {
            completion(false)
            return
        }
        
        let url = "http://43.201.191.12:8080/api/user/refresh"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: RefreshTokenResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("[AuthInterceptor] AccessToken 갱신 성공: \(data.accessToken)")
                    SessionStorage.shared.accessToken = data.accessToken
                    completion(true)
                case .failure(let error):
                    print("[AuthInterceptor] AccessToken 갱신 실패: \(error)")
                    completion(false)
                }
            }
    }
}
