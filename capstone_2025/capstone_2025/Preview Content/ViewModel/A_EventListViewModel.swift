//
//  EventListViewModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation

final class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private(set) var clubId: Int?
    
    func setClubId(_ id: Int) {
        self.clubId = id
    }


    func fetchEvents(for clubId: Int) {
        guard let accessToken = SessionStorage.shared.accessToken else {
            self.errorMessage = "AccessToken이 없습니다"
            return
        }

        isLoading = true
        errorMessage = nil

        EventAPI.fetchEvents(clubId: clubId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let dtos):
                    print(dtos)
                    self?.events = dtos.map { Event(from: $0) }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    
}
extension EventListViewModel {
    func createEvent(
        startTime: Date,
        endTime: Date,
        description: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let clubId = clubId,
              let accessToken = SessionStorage.shared.accessToken else {
            print("[ViewModel] ❌ clubId 또는 accessToken 누락")
            completion(false)
            return
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let request = EventRequestDTO(
            clubId: clubId,
            eventStartTime: formatter.string(from: startTime),
            eventEndTime: formatter.string(from: endTime),
            eventDescription: description
        )

        EventAPI.createEvent(request: request, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchEvents(for: clubId) // 성공 후 목록 리로드
                    completion(true)
                case .failure(let error):
                    print("[ViewModel] ❌ 이벤트 생성 실패: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
