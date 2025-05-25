//
//  Event.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation

struct Event: Identifiable, Hashable {
    let id = UUID()
    let eventId : Int
    let clubId: Int?
    let startTime: Date
    let endTime: Date
    let description: String


    static let legacyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // 서버가 UTC 기준이면 필수
        return formatter
    }()


    init(from dto: EventResponseDTO) {
        self.eventId = dto.eventId
        self.clubId = dto.clubId
        guard let start = Event.legacyFormatter.date(from: dto.eventStartTime!)//DateFormatter.notificationDateFormatter.date(from:dto.eventStartTime!)
        else {
            preconditionFailure("❌ 시작시간 파싱 실패: \(dto.eventStartTime!)")
        }
        self.startTime = start

        guard let end = Event.legacyFormatter.date(from: dto.eventEndTime!) /*DateFormatter.notificationDateFormatter.date(from:dto.eventEndTime!)*/ else {
            preconditionFailure("❌ 종료시간 파싱 실패: \(dto.eventEndTime!)")
        }
        self.endTime = end

        self.description = dto.eventDescription!
    }


}

extension Event {
    init(eventId: Int, clubId: Int, startTime: Date, endTime: Date, description: String) {
        self.eventId = eventId
        self.clubId = clubId
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
    }
}
