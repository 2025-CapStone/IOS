//
//  Club.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/20/25.
//

import Foundation


struct Club: Identifiable, Hashable {
    let id: Int
    var name: String
    var description: String
    var logoURL: String?
    var backgroundURL: String?
    let createdAt: Date
    
    
    init(from dto: ClubResponseDTO) {
        self.id = dto.clubId
        self.name = dto.clubName
        self.description = dto.clubDescription
        self.logoURL = dto.clubLogoURL
        self.backgroundURL = dto.clubBackgroundURL
        self.createdAt = ISO8601DateFormatter().date(from: dto.clubCreatedAt) ?? Date()
    }
    
    // 🔧 추가해 주세요
    init(id: Int, name: String, description: String, logoURL: String?, backgroundURL: String?, createdAt: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.logoURL = logoURL
        self.backgroundURL = backgroundURL
        self.createdAt = createdAt
    }
}
