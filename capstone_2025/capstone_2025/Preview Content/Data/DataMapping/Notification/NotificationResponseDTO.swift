//
//  NotificationResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//

import Foundation

// ✅ 서버 응답용 DTO
struct NotificationResponseDTO: Codable, Identifiable, Hashable {
    let id: Int?
    let title: String?
    let message: String?
    let type: NotificationType?
    let read: Bool?
    let createdAt: String?
    let sender: String?
    let referenceId: Int64?
    let targetId: Int64?

    enum CodingKeys: String, CodingKey {
        case id = "notificationId"
        case title
        case message
        case type
        case read = "read"
        case createdAt
        case sender
        case referenceId
        case targetId
    }
}

extension NotificationResponseDTO {
    func toEntity() -> Notification {
        Notification(
            id: id!,
            title: title!,
            message: message!,
            sender: sender!,
            createdAt: DateFormatter.notificationDateFormatter.date(from: createdAt!) ?? Date(),
            type: type!,
            isRead: read!
        )
    }
}

enum NotificationType: String, Codable {
    case joinRequest = "JOIN_REQUEST"
    case guestRequest = "GUEST_REQUEST"
    case approved = "APPROVED"
    case rejected = "REJECTED"
    case kicked = "KICKED"
    case eventAttendance = "EVENT_ATTENDANCE"
    case commentRequest = "COMMENT_REQUEST"
    case notice = "NOTICE"
    case system = "SYSTEM"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = NotificationType(rawValue: raw.uppercased()) ?? .unknown
    }
}
extension DateFormatter {
    static let notificationDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 백엔드가 UTC일 경우
        return formatter
    }()
}
