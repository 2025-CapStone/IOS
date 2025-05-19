//
//  RetryingNetworkService.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/6/25.
//

//import Foundation
//
//final class RetryingNetworkService: NetworkService {
//    private let wrapped: NetworkService
//
//    init(wrapping wrapped: NetworkService) {
//        self.wrapped = wrapped
//    }
//
//    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
//        return wrapped.request(endpoint: endpoint) { result in
//            switch result {
//            case .failure(let error) where error.isUnauthorized:
//                self.refreshToken { success in
//                    if success {
//                        _ = self.wrapped.request(endpoint: endpoint, completion: completion)
//                    } else {
//                        completion(.failure(error))
//                    }
//                }
//            default:
//                completion(result)
//            }
//        }
//    }
//
//    private func refreshToken(completion: @escaping (Bool) -> Void) {
//        guard let refresh = UserDefaults.standard.string(forKey: "refreshToken") else {
//            self.logoutUser()
//            completion(false)
//            return
//        }
//
//        let endpoint = APIEndpoints.refreshToken(refresh)
//        _ = wrapped.request(endpoint: endpoint) { result in
//            switch result {
//            case .success(let data):
//                guard let data = data else {
//                    self.logoutUser()
//                    completion(false)
//                    return
//                }
//
//                do {
//                    let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: data)
//                    UserDefaults.standard.set(dto.accessToken, forKey: "accessToken")
//                    UserDefaults.standard.set(dto.refreshToken, forKey: "refreshToken")
//                    completion(true)
//                } catch {
//                    self.logoutUser()
//                    completion(false)
//                }
//
//            case .failure:
//                self.logoutUser()
//                completion(false)
//            }
//        }
//
//    }
//
//    private func logoutUser() {
//        UserDefaults.standard.removeObject(forKey: "accessToken")
//        UserDefaults.standard.removeObject(forKey: "refreshToken")
//        AppState.shared.userId = nil
//        AppState.shared.isLoggedIn = false
//    }
//
//}

import Foundation

final class RetryingNetworkService: NetworkService {
    private let wrapped: NetworkService

    init(wrapping wrapped: NetworkService) {
        self.wrapped = wrapped
    }

    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        return wrapped.request(endpoint: endpoint) { result in
            switch result {
            case .failure(let error) where error.isUnauthorized:
                self.handleUnauthorizedError(endpoint: endpoint, completion: completion)
            default:
                completion(result)
            }
        }
    }

    private func handleUnauthorizedError(endpoint: Requestable, completion: @escaping CompletionHandler) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            self.logoutUser()
            completion(.failure(.unauthorized))
            return
        }

        // 토큰 재발급 시도
        self.refreshToken(refreshToken: refreshToken) { success in
            if success {
                _ = self.wrapped.request(endpoint: endpoint, completion: completion)
            } else {
                self.logoutUser()
                completion(.failure(.unauthorized))
            }
        }
    }

    private func refreshToken(refreshToken: String, completion: @escaping (Bool) -> Void) {
        let endpoint = APIEndpoints.refreshToken(refreshToken)

        _ = wrapped.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                guard let data = data,
                      let dto = try? JSONDecoder().decode(LoginResponseDTO.self, from: data) else {
                    completion(false)
                    return
                }
                UserDefaults.standard.set(dto.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(dto.refreshToken, forKey: "refreshToken")
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func logout(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            self.logoutUser()
            completion(false)
            return
        }

        let endpoint = APIEndpoints.logout(refreshToken)
        _ = wrapped.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                self.logoutUser()
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    private func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        AppState.shared.user = nil                    // ✅ user 정보 제거
        AppState.shared.isLoggedIn = false            // ✅ 로그인 상태 false 처리
    }
}



