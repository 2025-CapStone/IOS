//
//  EventAPI.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation
import Alamofire

enum EventAPI {
    static func fetchEvents(clubId: Int, accessToken: String, completion: @escaping (Result<[EventResponseDTO], Error>) -> Void) {
        let url = "http://43.201.191.12:8080/api/event/get-event/club_id?clubId=\(clubId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [EventResponseDTO].self) { response in
                switch response.result {
                case .success(let events):
                    completion(.success(events))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
