//
//  ClubResponseDTO 2.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//
import Foundation

struct ClubResponseDTO: Decodable {
    let clubId: Int
    let clubName: String
    let clubDescription: String
    let clubLogoURL: String?
    let clubBackgroundURL: String?
    let clubCreatedAt: String
    let tag: [String]

    private enum CodingKeys: String, CodingKey {
        case clubId = "club_id"
        case clubName
        case clubDescription
        case clubLogoURL
        case clubBackgroundURL = "clubBackgroundImageURL"
        case clubCreatedAt = "clubWhenCreated"
        case tag
    }

    // ✅ 커스텀 디코딩 구현
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        clubId            = try container.decode(Int.self, forKey: .clubId)
        clubName          = try container.decode(String.self, forKey: .clubName)
        clubDescription   = try container.decode(String.self, forKey: .clubDescription)
        clubLogoURL       = try container.decodeIfPresent(String.self, forKey: .clubLogoURL)
        clubBackgroundURL = try container.decodeIfPresent(String.self, forKey: .clubBackgroundURL)
        clubCreatedAt     = try container.decode(String.self, forKey: .clubCreatedAt)

        // ✅ 태그가 없거나 null인 경우 랜덤 태그 생성
        if let decodedTags = try? container.decodeIfPresent([String].self, forKey: .tag) {
            tag = decodedTags ?? ClubResponseDTO.generateRandomTags()
        } else {
            tag = ClubResponseDTO.generateRandomTags()
        }
    }

    // ✅ 랜덤 태그 생성 함수
    static func generateRandomTags() -> [String] {
        let samples = ["테니스", "운동", "자유", "소셜", "야외", "모임", "주말", "도전", "친목", "실내"]
        let count = Int.random(in: 1...3)
        return Array(samples.shuffled().prefix(count))
    }
}


extension ClubResponseDTO {
    init(
        clubId: Int,
        clubName: String,
        clubDescription: String,
        clubLogoURL: String? = nil,
        clubBackgroundURL: String? = nil,
        clubCreatedAt: String = ISO8601DateFormatter().string(from: Date()),
        tag: [String] = ["Demo"]
    ) {
        self.clubId = clubId
        self.clubName = clubName
        self.clubDescription = clubDescription
        self.clubLogoURL = clubLogoURL
        self.clubBackgroundURL = clubBackgroundURL
        self.clubCreatedAt = clubCreatedAt
        self.tag = tag
    }
}


//struct ClubResponseDTO: Decodable {
//    let clubId: Int
//    let clubName: String
//    let clubDescription: String
//    let clubLogoURL: String?
//    let clubBackgroundURL: String?
//    let clubCreatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case clubId = "club_id"
//        case clubName
//        case clubDescription
//        case clubLogoURL
//        case clubBackgroundURL = "clubBackgroundImageURL"
//        case clubCreatedAt = "clubWhenCreated"
//    }
//}
