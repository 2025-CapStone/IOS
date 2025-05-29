//
//  ScheduleCheckPopup.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//
import EventKit
import SwiftUI


struct ScheduleCheckPopup: View {
    @State private var showGuestJoinAlert = false
    @State private var showCalendarAlert = false
    @State private var showSuccessToast = false
    @State private var toastMessage = ""

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

        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text(schedule.startTime.formattedDateKorean())
                        .font(.title).bold().padding(.bottom, 10)
                    Spacer()

                    Button {
                        showCalendarConfirmationAlert()
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)

                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.gray)
                        Text("시작 : \(schedule.startTime.formattedTimeKorean())")
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.3)))

                    HStack {
                        Image(systemName: "play.fill")
                            .foregroundColor(.gray)
                        Text("종료 : \(schedule.endTime.formattedTimeKorean())")
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.3)))
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
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.3)))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(participantViewModel.participants) { participant in
                        ParticipantListViewCell(participant: participant)
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white).opacity(100))
                    }
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.3)))
                .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text("\u{274C} \(errorMessage)").foregroundColor(.red).padding(.top, 5)
                }

                Button(action: {
                    Task {
                        do {
                            switch participantState {
                            case .notParticipated:
                                try await participantViewModel.join(eventId: schedule.eventId)
                                isJoined = true
                                showToast("이 일정에 참석 처리되었습니다.")
                            case .GuestNotParticipated:
                                try await participantViewModel.joinAsGuest(eventId: schedule.eventId)
                                isJoined = true
                                showToast("게스트로 참석 처리되었습니다.")
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

            if showSuccessToast {
                Text(toastMessage)
                    .font(.caption)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 40)
            }
        }
        .alert("선택한 일정을 달력에 추가하시겠습니까?", isPresented: $showCalendarAlert) {
            Button("예") {
                saveAtCalendar(schedule: schedule) { result in
                    DispatchQueue.main.async {
                        showCalendarSaveResultAlert(result)
                    }
                }
            }
            Button("아니오", role: .cancel) {}
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        showSuccessToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSuccessToast = false
            }
        }
    }

    private func computeParticipantState() -> ParticipantState {
        let isMember = isUserMember(of: schedule)
        switch (isMember, isJoined) {
        case (false, false): return .GuestNotParticipated
        case (false, true):  return .GuestParticipated
        case (true,  true):  return .Participated
        case (true,  false): return .notParticipated
        }
    }

    private func isUserMember(of event: Event) -> Bool {
        guard let clubId = event.clubId else { return true }
        let userClubs = AppState.shared.user!.joinedClub
        return userClubs.contains(where: { $0.clubId == clubId })
    }

    private func showCalendarConfirmationAlert() {
        showCalendarAlert = true
    }

    private func showCalendarSaveResultAlert(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            showToast("달력에 일정이 저장되었습니다.")
        case .failure(let error):
            showToast(error.localizedDescription)
        }
    }

    private func saveAtCalendar(schedule: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard granted else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "캘린더 접근 권한이 없습니다."])));
                return
            }
            let event = EKEvent(eventStore: eventStore)
            event.title = schedule.description
            event.startDate = schedule.startTime
            event.endDate = schedule.endTime
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
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
        // ✅ AppState의 더미 유저 설정
        AppState.shared.user = User(
            id: "1",
            joinedClub: [
                ClubResponseDTO(
                    clubId: 1,
                    clubName: "Swift 클럽",
                    clubDescription: "SwiftUI 공부 모임",
                    clubLogoURL: nil,
                    clubBackgroundURL: nil,
                    clubCreatedAt: "2025-05-19T12:00:00Z",
                    tagOne: "Swift",
                    tagTwo: "iOS",
                    tagThree: "스터디"
                )
            ]
        )

        // ✅ 더미 이벤트
        let dummyEvent = Event(
            eventId: 1,
            clubId: 1,
            startTime: Date(),
            endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
            description: "프리뷰 이벤트입니다"
        )

        // ✅ 더미 참가자 뷰모델
        let viewModel = ParticipantViewModel()
        viewModel.participants = [
//            Participant(
//                id: 1,
//                name: "홍길동",
//                gender: "남성",
//                career: 3,
//                gameCount: 10,
//                lastGamedAt: Date()
//            ),
//            Participant(
//                id: 2,
//                name: "김철수",
//                gender: "남성",
//                career: 2,
//                gameCount: 5,
//                lastGamedAt: Date()
//            )
        ]

        return ScheduleCheckPopup(
            schedule: dummyEvent,
            isJoined: false,
            showPopup: .constant(true),
            participantViewModel: viewModel
        )
        .previewDisplayName("ScheduleCheckPopup Preview")
    }
}

