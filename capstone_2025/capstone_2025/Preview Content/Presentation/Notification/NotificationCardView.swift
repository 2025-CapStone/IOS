//
//  NotificationCardView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//


import SwiftUI

struct NotificationCardView: View {
    let notification: Notification
    let onClick: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(emoji(for: notification.type))
                    .font(.title2)

                Text(notification.title)
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                Button(action: { onDelete() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
            }

            Text(notification.message)
                .font(.system(size: 14))
                .foregroundColor(.black)

            Text("\(notification.sender) · \(formatted(notification.createdAt))")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .background(notification.isRead ? Color(UIColor.systemGray6) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(notification.isRead ? Color.gray.opacity(0.3) : Color.green, lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(radius: 1)
        .onTapGesture {
            onClick()
        }
    }
    private func emoji(for type: NotificationType) -> String {
        switch type {
        case .joinRequest:      return "🙋"   // 가입 신청
        case .guestRequest:     return "🕒"   // 게스트 요청
        case .approved:         return "👍"   // 승인됨
        case .rejected:         return "❌"   // 거절됨
        case .kicked:           return "🚫"   // 강퇴
        case .eventAttendance:  return "🎾"   // 출석 확인
        case .commentRequest:   return "📝"   // 후기 요청
        case .notice:           return "📢"   // 일반 알림
        case .system:           return "⚙️"   // 시스템
        case .unknown:          return "❓"   // 알 수 없음
        }
    }


    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.string(from: date)
    }
}
