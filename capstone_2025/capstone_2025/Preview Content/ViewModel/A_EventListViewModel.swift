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
    // Event 변수가 하나 밖에 없는데 Race Condition의 우려?
    func setClubId(_ id: Int) {
        self.clubId = id
        print("EventListViewModel Created|| \(Date())")
    }


    func fetchClubEvents(for clubId: Int) {
        guard let accessToken = SessionStorage.shared.accessToken else {
            self.errorMessage = "AccessToken이 없습니다"
            return
        }

        isLoading = true
        errorMessage = nil

        EventAPI.fetchClubEvents(clubId: clubId, accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let dtos):
                    print("[EventAPI] ✅ 응답 DTO: \(dtos)")
                    let mapped = dtos.map { Event(from: $0) }
                    for e in mapped {
                        print("[Mapped] \(e.eventId) - start: \(e.startTime), end: \(e.endTime)")
                    }
                    self?.events = mapped
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
     
     
     
     func fetchClubUserEvents() {
         guard let accessToken = SessionStorage.shared.accessToken else {
             self.errorMessage = "AccessToken이 없습니다"
             return
         }
         guard let userId = AppState.shared.user?.id else {
             self.errorMessage = "UserID가 없습니다"
             return
         }

         isLoading = true
         errorMessage = nil

         EventAPI.fetchClubUserEvents(userId: Int(userId)!, accessToken: accessToken) { [weak self] result in
             DispatchQueue.main.async {
                 self?.isLoading = false
                 switch result {
                 case .success(let dtos):
                     print("[EventAPI] ✅ 응답 DTO: \(dtos)")
                     let mapped = dtos.map { Event(from: $0) }
                     for e in mapped {
                         print("[Mapped] \(e.eventId) - start: \(e.startTime), end: \(e.endTime)")
                     }
                     self?.events = mapped
                     
                 case .failure(let error):
                     self?.errorMessage = error.localizedDescription
                 }
             }
         }
     }
     
     
     func fetchUserEvents() {
         guard let accessToken = SessionStorage.shared.accessToken else {
             self.errorMessage = "AccessToken이 없습니다"
             return
         }
         guard let userId = AppState.shared.user?.id else {
             self.errorMessage = "UserID가 없습니다"
             return
         }

         isLoading = true
         errorMessage = nil

         EventAPI.fetchUserEvents(userId: Int(userId)!, accessToken: accessToken) { [weak self] result in
             DispatchQueue.main.async {
                 self?.isLoading = false
                 switch result {
                 case .success(let dtos):
                     print("[EventAPI] ✅ 응답 DTO: \(dtos)")
                     let mapped = dtos.map { Event(from: $0) }
                     for e in mapped {
                         print("[Mapped] \(e.eventId) - start: \(e.startTime), end: \(e.endTime)")
                     }
                     self?.events = mapped
                     
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
                    print("[EventListViewModel]  이벤트 생성 성공 \(result))")

                    self?.fetchClubEvents(for: clubId) // 성공 후 목록 리로드
                    
                    completion(true)
                case .failure(let error):
                    print("[EventList   ViewModel] ❌ 이벤트 생성 실패: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
