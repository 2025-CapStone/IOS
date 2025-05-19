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
    let career: Int
    let gameCount: Int?

    private let lastGamedAtRaw: String?

    // ✅ 필요한 형식으로 변환
    var lastGamedAt: Date? {
        guard let dateString = lastGamedAtRaw else { return nil }
        return ISO8601DateFormatter().date(from: dateString)
    }

    enum CodingKeys: String, CodingKey {
        case userId, userName, gender, career, gameCount
        case lastGamedAtRaw = "lastGamedAt" // ✅ 내부 디코딩 키
    }
}
