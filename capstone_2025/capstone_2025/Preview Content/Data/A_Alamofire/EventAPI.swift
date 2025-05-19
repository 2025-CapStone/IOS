//
//  EventAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation
import Alamofire

enum EventAPI {
    static func fetchClubEvents(clubId: Int, accessToken: String, completion: @escaping (Result<[EventResponseDTO], Error>) -> Void) {
        let url = "http://43.201.191.12:8080/api/event/get-event/club_id?clubId=\(clubId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [EventResponseDTO].self) { response in
                print(response)

                switch response.result {
                    
                case .success(let events):
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    static func fetchClubUserEvents(userId : Int,accessToken: String, completion: @escaping (Result<[EventResponseDTO], Error>) -> Void) {
        let url = "http://43.201.191.12:8080/api/event/get-event/user_id?userId=\(userId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let request = AF.request(url, method: .get, headers: headers)
        
        // ✅ cURL 출력
        request.cURLDescription { description in
            print("[fetchClubUserEvents] 🔍 cURL:\n\(description)")
        }
        
        request
            .validate()
            .responseDecodable(of: [EventResponseDTO].self) { response in
                print(response)

                switch response.result {
                case .success(let events):
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    static func createEvent(
        request: EventRequestDTO,
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let url = "http://43.201.191.12:8080/api/event/add-event"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let dataRequest = AF.request(
            url,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        
        // ✅ cURL 로그 출력
        dataRequest.cURLDescription { curl in
            print("[EventAPI] 🌀 cURL:\n\(curl)")
        }
        
        // 응답 처리
        dataRequest
            .validate()
            .responseString { response in
                print(response)

                switch response.result {
                case .success(let message):
                    print("[EventAPI] ✅ 이벤트 생성 성공: \(message)")
                    completion(.success(message))
                case .failure(let error):
                    print("[EventAPI] ❌ 이벤트 생성 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    
    
    static func fetchUserEvents(userId : Int,accessToken: String, completion: @escaping (Result<[EventResponseDTO], Error>) -> Void) {
        
        
        let url = "http://43.201.191.12:8080/api/participant/all/by_user_id"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "userId": userId
        ]
        
        let request = AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,headers: headers)
        
        // ✅ cURL 출력
        request.cURLDescription { description in
            print("[fetchUserEvents] 🔍 cURL:\n\(description)")
        }
        
        request
            .validate()
            .responseDecodable(of: [EventResponseDTO].self) { response in
                print(response)
                switch response.result {
                case .success(let events):
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
        
