//
//  NotificationDetailModal.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//


import SwiftUI

struct NotificationDetailModal: View {
    let notification: Notification
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text(notification.title)
                .font(.title2).bold()

            Text(notification.message)
                .font(.body)

            Text("보낸 사람: \(notification.sender)")
                .font(.footnote)
                .foregroundColor(.gray)

            Text(formatted(notification.createdAt))
                .font(.footnote)
                .foregroundColor(.gray)

            Button("닫기") {
                dismiss()
            }
            .padding(.top, 20)
        }
        .padding()
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: date)
    }
}
