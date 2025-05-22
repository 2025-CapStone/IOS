//
//  Notification.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//

import Foundation

struct Notification: Identifiable, Hashable {
    let id: Int
    let title: String
    let message: String
    let sender: String
    let createdAt: Date
    let type: NotificationType
    var isRead: Bool
}
