//
//  MembershipAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/12/25.
//
// Non-DTO

import Alamofire

enum MembershipAPI {
    
    
    static func joinClub(
        userId: Int,
        clubId: Int,
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let url = "https://api.on-club.co.kr/api/membership/join/request"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "userId": userId,
            "clubId": clubId
        ]

        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseString { response in
            switch response.result {
            case .success(let message):
                print("[MembershipAPI] ✅ 클럽 가입 성공: \(message)")
                completion(.success(message))
            case .failure(let error):
                print("[MembershipAPI] ❌ 클럽 가입 실패: \(error)")
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("[MembershipAPI] ⚠️ 응답 본문: \(raw)")
                }
                completion(.failure(error))
            }
        }
    }
}
