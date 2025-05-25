//
//  NotificationViewModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//


import Foundation

final class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var selectedNotification: Notification? = nil
    @Published var errorMessage: String? = nil

    func fetchAll() {
        guard let accessToken = SessionStorage.shared.accessToken,
              let userId = Int(AppState.shared.user?.id ?? "") else {
            self.errorMessage = "인증 정보가 없습니다"
            return
        }

        NotificationAPI.fetchAll(userId: userId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dtos):
                    self?.notifications = dtos.map { dto in
                        dto.toEntity()
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func markAsRead(id: Int) {
        guard let accessToken = SessionStorage.shared.accessToken else { return }

        NotificationAPI.markAsRead(notificationId: id, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                if case .success = result {
                    if let index = self?.notifications.firstIndex(where: { $0.id == id }) {
                        self?.notifications[index].isRead = true
                    }
                } else if case .failure(let error) = result {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteNotification(id: Int) {
        guard let accessToken = SessionStorage.shared.accessToken else { return }

        NotificationAPI.delete(notificationId: id, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                if case .success = result {
                    self?.notifications.removeAll { $0.id == id }
                } else if case .failure(let error) = result {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func select(_ noti: Notification) {
        selectedNotification = noti
    }

    func deselect() {
        selectedNotification = nil
    }

    private static func dateFromISO(_ iso: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter.date(from: iso) ?? Date()
    }
}
