//
//  Participant.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import Foundation

struct Participant: Identifiable, Hashable {
    let id: Int
    let name: String
    let gender: String
    let career: Int
    let gameCount: Int?
    let lastGamedAt: Date?
}
extension Participant {
    init(from dto: ParticipantResponseDTO) {
        self.id = dto.userId
        self.name = dto.userName!
        self.gender = dto.gender!
        self.career = dto.career!
        self.gameCount = dto.gameCount
        self.lastGamedAt = dto.lastGamedAt
    }
}
