//
//  EventRequestDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/6/25.
//


struct EventRequestDTO: Encodable {
    let clubId: Int
    let eventStartTime: String
    let eventEndTime: String
    let eventDescription: String
}
