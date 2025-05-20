//
//  ClubAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//

import Alamofire


enum ClubAPI {
    static let baseURL = "https://api.on-club.co.kr"


    static func fetchAllClubs(accessToken: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void) {
        let url = "\(baseURL)/api/club/find/all"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        let request = AF.request(url, method: .get, headers: headers)

        // ✅ Raw Response 출력
        request.responseData { response in
            if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                print("[ClubAPI] 📦 Raw Response:\n\(rawString)")
            }
        }

        // ✅ 디코딩 처리
        request.validate(statusCode: 200..<300)
            .responseDecodable(of: [ClubResponseDTO].self) { response in
                switch response.result {
                case .success(let clubs):
                    print("[ClubAPI] ✅ 모든 클럽 조회 성공: \(clubs.count)개")
                    completion(.success(clubs))
                case .failure(let error):
                    print("[ClubAPI] ❌ 모든 클럽 조회 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    
    
    static func fetchJoinedClubs(userId: Int, accessToken: String, completion: @escaping (Result<[ClubResponseDTO], Error>) -> Void) {
        let url = "\(baseURL)/api/club/find/by-user_id"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["userId": userId]

        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [ClubResponseDTO].self) { response in
            switch response.result {
            case .success(let clubs):
                print("[ClubAPI] ✅ clubs count: \(clubs.count)")
                
                completion(.success(clubs))
            case .failure(let error):
                print("[ClubAPI] ❌ error: \(error.localizedDescription)")
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("[ClubAPI] ⚠️ raw response: \(raw)")
                }
                completion(.failure(error))
            }
        }
    }
    
    /// ✅ clubId로 클럽 단일 정보 조회
    static func findClubById(clubId: Int, accessToken: String, completion: @escaping (Result<ClubResponseDTO, Error>) -> Void) {
        let url = "\(baseURL)/api/club/find/by-club_id"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["clubId": clubId]

        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ClubResponseDTO.self) { response in
            switch response.result {
            case .success(let club):
                print("[ClubAPI] ✅ club found: \(club.clubName)")
                print("[ClubAPI] ✅ club found: \(club)")

                completion(.success(club))
            case .failure(let error):
                print("[ClubAPI] ❌ failed to fetch club: \(error.localizedDescription)")
                if let data = response.data, let raw = String(data: data, encoding: .utf8) {
                    print("[ClubAPI] ⚠️ raw response: \(raw)")
                }
                completion(.failure(error))
            }
        }
    }
}
