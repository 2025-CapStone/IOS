//
//  ParticipantViewModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import Foundation

final class ParticipantViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // 참가자 불러오기
    func fetchParticipants(eventId: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let dtos = try await ParticipantAPI.fetchAll(eventId: eventId)
            DispatchQueue.main.async {
                self.participants = dtos.map { Participant(from: $0) }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.participants = []
            }
        }

        isLoading = false
    }

    // 일반 참가
    func join(eventId: Int) async throws {
        guard let userId = AppState.shared.user?.id else {
            throw URLError(.userAuthenticationRequired)
        }
        _ = try await ParticipantAPI.join(userId: Int(userId)!, eventId: eventId)
    }

    // 게스트 참가
    func joinAsGuest(eventId: Int) async throws {
        guard let userId = AppState.shared.user?.id else {
            throw URLError(.userAuthenticationRequired)
        }
        _ = try await ParticipantAPI.joinclubByGuest(userId: Int(userId)!, eventId: eventId)
    }

    // 참가 여부 확인
    func isUserJoined(userId: Int?, eventId: Int) async -> Bool {
        guard let id = userId else { return false }
        do {
            let dtos = try await ParticipantAPI.fetchAll(eventId: eventId)
            return dtos.contains { $0.userId == id }
        } catch {
            return false
        }
    }
}
