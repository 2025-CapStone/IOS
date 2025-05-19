//
//  ScheduleCheckPopupWrapper.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//
import SwiftUI
import Alamofire
//
//  ScheduleCheckPopupWrapper.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//

import SwiftUI
import SwiftUI

struct ScheduleCheckPopupWrapper: View {
    let event: Event
    @Binding var showPopup: Bool

    @StateObject private var participantViewModel = ParticipantViewModel()
    @State private var isLoading = true
    @State private var isJoined = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("참가자 확인 중...")
            } else {
                ScheduleCheckPopup(
                    schedule: event,
                    isJoined: isJoined,
                    showPopup: $showPopup,
                    participantViewModel: participantViewModel
                )
            }
        }
        .task {
            await loadParticipants()
        }
    }

    // ✅ 분리된 로딩 함수
    private func loadParticipants() async {
        await participantViewModel.fetchParticipants(eventId: event.eventId)

        if let currentUserId = AppState.shared.user?.id {
            isJoined = participantViewModel.participants.contains { $0.id == Int(currentUserId) }
        } else {
            isJoined = false
        }

        isLoading = false
    }
}

struct ScheduleCheckPopupWrapper_Previews: PreviewProvider {
    static var previews: some View {
        let previewViewModel = ParticipantViewModel()
        previewViewModel.participants = [
            Participant(
                id: 1,
                name: "홍길동",
                gender: "남성",
                career: 3,
                gameCount: 12,
                lastGamedAt: Date()
            ),
            Participant(
                id: 2,
                name: "김영희",
                gender: "여성",
                career: 2,
                gameCount: 5,
                lastGamedAt: nil
            )
        ]
        
        // 더미 ClubResponseDTO 하나 생성
        let dummyClub = ClubResponseDTO(
            clubId: 1,
            clubName: "Swift 클럽",
            clubDescription: "Swift 동호회입니다",
            clubLogoURL: nil,
            clubBackgroundURL: nil,
            clubCreatedAt: "2025-01-01T00:00:00",
            tagOne: "Swift",
            tagTwo: "iOS",
            tagThree: "스터디"

        )

        // AppState 프리뷰용 설정
        AppState.shared.user = User(
            id: "1",
            joinedClub: [dummyClub]
        )


        return ScheduleCheckPopupWrapper(
            event: Event(
                eventId: 1,
                clubId: 1,
                startTime: Date(),
                endTime: Date().addingTimeInterval(3600),
                description: "프리뷰용 일정"
            ),
            showPopup: .constant(true)
        )
    }
}
