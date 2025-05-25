//
//  EventResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


struct EventResponseDTO: Decodable {
    let eventId : Int
    let clubId: Int?
    let eventStartTime: String?
    let eventEndTime: String?
    let eventDescription: String?

    private enum CodingKeys: String, CodingKey {
        case eventId
        case clubId
        case eventStartTime
        case eventEndTime
        case eventDescription
    }
}

