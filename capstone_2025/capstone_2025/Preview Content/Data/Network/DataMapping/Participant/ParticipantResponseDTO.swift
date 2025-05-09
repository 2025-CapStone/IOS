//
//  ParticipantResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//


import Foundation

struct ParticipantResponseDTO: Codable, Identifiable, Hashable {
    var id: Int { userId }

    let userId: Int
    let userName: String
    let gender: String
    let lastGamedAt: Date?
    let career: Int
    let gameCount: Int?

    enum CodingKeys: String, CodingKey {
        case userId
        case userName
        case gender
        case lastGamedAt
        case career
        case gameCount
    }
}
