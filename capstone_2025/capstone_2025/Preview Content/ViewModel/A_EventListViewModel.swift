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
                    self?.events = dtos.map { Event(from: $0) }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
