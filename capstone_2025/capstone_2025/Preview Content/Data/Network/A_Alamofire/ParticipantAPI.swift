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

    static func fetchAll(eventId: Int) async throws -> [ParticipantResponseDTO] {
        let path = "/api/participant/all"
        let parameters: [String: Any] = [
            "eventId": eventId
        ]

        let data = try await SecuredAPI.shared.request(
            path: path,
            method: .get,
            parameters: parameters
        )
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([ParticipantResponseDTO].self, from: data)
    }
}
