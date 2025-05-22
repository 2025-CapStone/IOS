//
//  NotificationAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//

import Foundation
import Alamofire

enum NotificationAPI {
    static func fetchAll(userId: Int, accessToken: String, completion: @escaping (Result<[NotificationResponseDTO], Error>) -> Void) {
        let url = "https://api.on-club.co.kr/api/notification/all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["userId": userId]

        let request = AF.request(url, method: .get, parameters: parameters, headers: headers)

        debugPrint("[NotificationAPI] 🔍 fetchAll request: \(request)")
        
        request
            .validate()
            .responseDecodable(of: [NotificationResponseDTO].self) { response in
                switch response.result {
                case .success(let notifications):
                    print("[NotificationAPI] ✅ fetchAll response: \(notifications)")
                    completion(.success(notifications))
                case .failure(let error):
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("[NotificationAPI] ❌ fetchAll raw response: \(rawString)")
                    }
                    print("[NotificationAPI] ❌ fetchAll error: \(error)")
                    completion(.failure(error))
                }
            }
    }

    static func delete(notificationId: Int, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.on-club.co.kr/api/notification"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["notificationId": notificationId]

        let request = AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers)

        debugPrint("[NotificationAPI] 🔍 delete request: \(request)")

        request
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let message):
                    print("[NotificationAPI] ✅ delete response: \(message)")
                    completion(.success(message))
                case .failure(let error):
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("[NotificationAPI] ❌ delete raw response: \(rawString)")
                    }
                    print("[NotificationAPI] ❌ delete error: \(error)")
                    completion(.failure(error))
                }
            }
    }

    static func markAsRead(notificationId: Int, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.on-club.co.kr/api/notification/read"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["notificationId": notificationId]

        let request = AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers)

        debugPrint("[NotificationAPI] 🔍 markAsRead request: \(request)")

        request
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let message):
                    print("[NotificationAPI] ✅ markAsRead response: \(message)")
                    completion(.success(message))
                case .failure(let error):
                    if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                        print("[NotificationAPI] ❌ markAsRead raw response: \(rawString)")
                    }
                    print("[NotificationAPI] ❌ markAsRead error: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
