//
//  ParticipantAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//


import Foundation
import Alamofire

enum ParticipantAPI {
    static func join(userId: Int, eventId: Int) async throws -> Bool {
        let path = "/api/participant/join"
        let parameters: [String: Any] = [
            "userId": userId,
            "eventId": eventId
        ]
        _ = try await SecuredAPI.shared.request(
            path: path,
            method: .post,
            parameters: parameters
        )
        return true
    }
    
    //    static func fetchAll(eventId: Int) async throws -> [ParticipantResponseDTO] {
    //        let path = "/api/participant/all"
    //        let parameters: [String: Any] = [
    //            "eventId": eventId
    //        ]
    //
    //        let data = try await SecuredAPI.shared.request(
    //            path: path,
    //            method: .get,
    //            parameters: parameters
    //        )
    //        let decoder = JSONDecoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
    //        return try decoder.decode([ParticipantResponseDTO].self, from: data)
    //    }
    //
    //    static func fetchAll(eventId: Int, accessToken: String, completion: @escaping (Result<[ParticipantResponseDTO], Error>) -> Void) {
    //        let url = "http://43.201.191.12:8080/api/participant/all?eventId=\(eventId)"
    //        let headers: HTTPHeaders = [
    //            "Authorization": "Bearer \(accessToken)",
    //            "Content-Type": "application/json"
    //        ]
    //
    //        AF.request(url, method: .get, headers: headers)
    //            .validate()
    //            .responseDecodable(of: [ParticipantResponseDTO].self) { response in
    //                switch response.result {
    //                case .success(let data):
    //                    completion(.success(data))
    //                case .failure(let error):
    //                    completion(.failure(error))
    //                }
    //            }
    //    }
    //}
    static func fetchAll(eventId: Int) async throws -> [ParticipantResponseDTO] {
        guard let accessToken = SessionStorage.shared.accessToken else {
            print("[ParticipantAPI] ❌ accessToken이 없습니다")
            throw URLError(.userAuthenticationRequired)
        }

        let url = "http://43.201.191.12:8080/api/participant/all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "eventId": eventId
        ]

        print("[ParticipantAPI] 🔍 URL: \(url)?eventId=\(eventId)")
        print("[ParticipantAPI] Headers: \(headers)")

        return try await withCheckedThrowingContinuation { continuation in
            let request = AF.request(
                url,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            )

            // 🔍 인코딩된 요청 확인 (cURL)
            request.cURLDescription { curl in
                print("[ParticipantAPI] 🌀 cURL:\n\(curl)")
            }

            // 🔍 Raw Data 출력
            request.responseData { rawResponse in
                if let data = rawResponse.data,
                   let rawString = String(data: data, encoding: .utf8) {
                    print("[ParticipantAPI] 📦 Raw Response:\n\(rawString)")
                }
            }

            request
                .validate()
                .responseDecodable(of: [ParticipantResponseDTO].self) { response in
                    switch response.result {
                    case .success(let participants):
                        print("[ParticipantAPI] ✅ 디코딩 성공: \(participants.count)명")
                        continuation.resume(returning: participants)
                    case .failure(let error):
                        print("[ParticipantAPI] ❌ 디코딩 실패: \(error)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

}
