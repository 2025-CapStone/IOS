//
//  ClubResponseDTO 2.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/29/25.
//
struct ClubResponseDTO: Decodable {
    let clubId: Int
    let clubName: String
    let clubDescription: String
    let clubLogoURL: String?
    let clubBackgroundURL: String?
    let clubCreatedAt: String

    private enum CodingKeys: String, CodingKey {
        case clubId = "club_id"
        case clubName
        case clubDescription
        case clubLogoURL
        case clubBackgroundURL = "clubBackgroundImageURL"
        case clubCreatedAt = "clubWhenCreated"
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
