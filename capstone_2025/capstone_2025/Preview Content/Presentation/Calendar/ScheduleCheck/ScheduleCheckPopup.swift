//
//  ScheduleCheckPopup.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import SwiftUI

struct ScheduleCheckPopup: View {
    @State private var showGuestJoinAlert = false

    let schedule: Event
    let isJoinedInitial: Bool
    @Binding var showPopup: Bool

    @State private var isJoined: Bool
    @State private var isLoading = false
    @State private var errorMessage: String?

    @ObservedObject var participantViewModel: ParticipantViewModel
    
    
    

    init(schedule: Event, isJoined: Bool, showPopup: Binding<Bool>, participantViewModel: ParticipantViewModel) {
        self.schedule = schedule
        self._isJoined = State(initialValue: isJoined)
        self.isJoinedInitial = isJoined
        self._showPopup = showPopup
        self.participantViewModel = participantViewModel
    }

    var body: some View {
        let participantState = computeParticipantState()
        VStack(spacing: 16) {
            HStack {
                Button(action: { showPopup = false }) {}
                Spacer()
                Text(schedule.startTime.formattedDateKorean())
                    .font(.title).bold().padding(.bottom, 10)
                Spacer()
                Button(action: { showPopup = false }) {}
            }
            .padding(.horizontal, 40).padding(.vertical, 10)

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.gray)
                    Text("시작 : \(schedule.startTime.formattedTimeKorean())")
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.gray)
                    Text("종료 : \(schedule.endTime.formattedTimeKorean())")
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
            .padding(.horizontal)

            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.gray)
                Text(schedule.description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(participantViewModel.participants) { participant in
                    Button(action: {
//                        participantViewModel.selectedParticipant = participant
                    }) {
                        ParticipantListViewCell(participant: participant)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text("\u{274C} \(errorMessage)").foregroundColor(.red).padding(.top, 5)
            }

//            if isJoined {
//                Text("\u{2705} 이미 참석한 일정입니다")
//                    .foregroundColor(.green)
//                    .bold()
//            }

            Button(action: {
                Task {
                    do {
                        switch participantState {
                        case .notParticipated:
                            try await participantViewModel.join(eventId: schedule.eventId)
                            isJoined = true
                        case .GuestNotParticipated:
                            try await participantViewModel.joinAsGuest(eventId: schedule.eventId)
                            isJoined = true
                        default:
                            break
                        }
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text(participantState.buttonText)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                }
            }
            .background(participantState.isButtonDisabled ? Color.gray.opacity(0.1) : Color.green.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(participantState.isButtonDisabled || isLoading)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
 
    
    
    private func computeParticipantState() -> ParticipantState {
        let isMember = isUserMember(of: schedule)

        switch (isMember, isJoined) {
        case (false, false): return .GuestParticipated
        case (false, true):  return .GuestNotParticipated
        case (true,  true):  return .Participated
        case (true,  false): return .notParticipated
        }
    }

    
    private func isUserMember(of event: Event) -> Bool {
        guard let clubId = event.clubId else {
            return true // clubId가 없으면 기본적으로 member로 간주
        }
        let userClubs = AppState.shared.user!.joinedClub
        return userClubs.contains(where: { $0.clubId == clubId })
    }

}

extension Date {
    func formattedTimeKorean() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: self)
    }

    func formattedDateKorean() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}


struct ScheduleCheckPopup_Previews: PreviewProvider {
    static var previews: some View {
        // AppState의 로그인 유저 설정 (프리뷰 전용)
        AppState.shared.user = User(
            id: "1",
            joinedClub: [
                ClubResponseDTO(
                    clubId: 1,
                    clubName: "Swift 클럽",
                    clubDescription: "SwiftUI 공부 모임",
                    clubLogoURL: nil,
                    clubBackgroundURL: nil,
                    clubCreatedAt: "String",
                    tag:  ["Demo","test"]

                )
            ]
        )

        let dummyEvent = Event(
            eventId: 1,
            clubId: 1,
            startTime: Date(),
            endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
            description: "프리뷰 이벤트"
        )

        let viewModel = ParticipantViewModel()
        viewModel.participants = [
            Participant(
                id: 1,
                name: "홍길동",
                gender: "남성",
                career: 3,
                gameCount: 10,
                lastGamedAt: Date()
            ),
            Participant(
                id: 2,
                name: "김철수",
                gender: "남성",
                career: 2,
                gameCount: 5,
                lastGamedAt: Date()
            )
        ]

        return ScheduleCheckPopup(
            schedule: dummyEvent,
            isJoined: true,
            showPopup: .constant(true),
            participantViewModel: viewModel
        )
    }
}
