//
//  Event.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation

struct Event: Identifiable, Hashable {
    let id = UUID()
    let clubId: Int
    let startTime: Date
    let endTime: Date
    let description: String

    init(from dto: EventResponseDTO) {
        self.clubId = dto.clubId
        self.startTime = ISO8601DateFormatter().date(from: dto.eventStartTime) ?? Date()
        self.endTime = ISO8601DateFormatter().date(from: dto.eventEndTime) ?? Date()
        self.description = dto.eventDescription
    }
}
