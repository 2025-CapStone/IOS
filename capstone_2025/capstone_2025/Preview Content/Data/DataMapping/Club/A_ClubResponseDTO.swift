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
    let tagOne: String
    let tagTwo: String
    let tagThree: String

    var tags: [String] {
        return [tagOne, tagTwo, tagThree].filter { !$0.isEmpty }
    }

    private enum CodingKeys: String, CodingKey {
        case clubId = "club_id"
        case clubName
        case clubDescription
        case clubLogoURL
        case clubBackgroundURL = "clubBackgroundImageURL"
        case clubCreatedAt = "clubWhenCreated"
        case tagOne, tagTwo, tagThree
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

        // ✅ 태그가 없거나 null인 경우 랜덤 생성
        tagOne = (try? container.decodeIfPresent(String.self, forKey: .tagOne)) ?? ClubResponseDTO.randomTag()
        tagTwo = (try? container.decodeIfPresent(String.self, forKey: .tagTwo)) ?? ClubResponseDTO.randomTag()
        tagThree = (try? container.decodeIfPresent(String.self, forKey: .tagThree)) ?? ClubResponseDTO.randomTag()
    }
}

// ✅ 랜덤 태그 유틸리티
extension ClubResponseDTO {
    static func randomTag() -> String {
        let samples = ["T테니스", "T운동", "T소셜", "T자유", "T모임", "T야외", "T주말", "T도전", "T실내", "T친목"]
        return samples.randomElement() ?? "T기본"
    }
    
    
    init(
        clubId: Int,
        clubName: String,
        clubDescription: String,
        clubLogoURL: String?,
        clubBackgroundURL: String?,
        clubCreatedAt: String,
        tagOne: String,
        tagTwo: String,
        tagThree: String
    ) {
        self.clubId = clubId
        self.clubName = clubName
        self.clubDescription = clubDescription
        self.clubLogoURL = clubLogoURL
        self.clubBackgroundURL = clubBackgroundURL
        self.clubCreatedAt = clubCreatedAt
        self.tagOne = tagOne
        self.tagTwo = tagTwo
        self.tagThree = tagThree
    }
}
