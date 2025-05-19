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
           guard let accessToken = SessionStorage.shared.accessToken else {
               throw URLError(.userAuthenticationRequired)
           }

           let url = "http://43.201.191.12:8080/api/participant/join?userId=\(userId)&eventId=\(eventId)"
           let headers: HTTPHeaders = [
               "Authorization": "Bearer \(accessToken)",
               "Content-Type": "application/x-www-form-urlencoded"
           ]

           return try await withCheckedThrowingContinuation { continuation in
               let request = AF.request(
                   url,
                   method: .post,
                   parameters: nil,  // ✅ requestBody 없음
                   encoding: URLEncoding.default,
                   headers: headers
               )

               // ✅ cURL 출력
               request.cURLDescription { curl in
                   print("[SecuredAPI] 🌀 cURL Query Request:\n\(curl)")
               }

               request
                   .validate()
                   .response { response in
                       switch response.result {
                       case .success:
                           continuation.resume(returning: true)
                       case .failure(let error):
                           continuation.resume(throwing: error)
                       }
                   }
           }
       }
    static func joinclubByGuest(userId: Int, eventId: Int) async throws -> Bool {
         guard let accessToken = SessionStorage.shared.accessToken else {
             throw URLError(.userAuthenticationRequired)
         }

         let url = "http://43.201.191.12:8080/api/guest/attend/request"
         let headers: HTTPHeaders = [
             "Authorization": "Bearer \(accessToken)",
             "Content-Type": "application/json"
         ]

         let parameters: [String: Any] = [
             "userId": userId,
             "eventId": eventId
         ]

         return try await withCheckedThrowingContinuation { continuation in
             let request = AF.request(
                 url,
                 method: .post,
                 parameters: parameters,
                 encoding: JSONEncoding.default,
                 headers: headers
             )

             // ✅ cURL 출력
             request.cURLDescription { curl in
                 print("[JoinAPI] 🌀 cURL Guest Join Request:\n\(curl)")
             }

             request
                 .validate()
                 .responseString { response in
                     switch response.result {
                     case .success(let message):
                         print("[JoinAPI] ✅ 게스트로 참석 성공: \(message)")
                         continuation.resume(returning: true)

                     case .failure(let error):
                         print("[JoinAPI] ❌ 게스트로 참석 실패: \(error.localizedDescription)")

                         if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                             print("[JoinAPI] ⚠️ 응답 본문: \(raw)")
                         }

                         continuation.resume(throwing: error)
                     }
                 }
         }
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
