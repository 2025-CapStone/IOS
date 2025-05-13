//
//  ScheduleCheckPopupWrapper.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//
import SwiftUI
import Alamofire

struct ScheduleCheckPopupWrapper: View {
    let event: Event
    @Binding var showPopup: Bool

    @State var isJoined: Bool = false
    @State var loading = true

    var body: some View {
        ZStack {
            if loading {
                ProgressView("참가자 확인 중...")
            } else {
                ScheduleCheckPopup(
                    schedule: Schedule(
                        eventId: event.eventId,
                        startTime: event.startTime.formatted(date: .omitted, time: .shortened),
                        endTime: event.endTime.formatted(date: .omitted, time: .shortened),
                        title: event.description
                    ),
                    isJoined: isJoined,
                    showPopup: $showPopup
                )
            }
        }
        .task {
            do {
                let participants = try await ParticipantAPI.fetchAll(eventId: event.eventId)
                let currentUserId = AppState.shared.user?.id
                print(participants)
                isJoined = participants.contains { $0.userId == Int(currentUserId!) }
            } catch {
                print("❌ 참가자 조회 실패: \(error)")
                isJoined = false
            }
            loading = false
        }
    }
}

struct ScheduleCheckPopup: View {
    @State private var showGuestJoinAlert = false

    let schedule: Schedule
    let isJoinedInitial: Bool
    @Binding var showPopup: Bool

    @State private var isJoined: Bool
    @State private var isLoading = false
    @State private var errorMessage: String?

    init(schedule: Schedule, isJoined: Bool, showPopup: Binding<Bool>) {
        self.schedule = schedule
        self._isJoined = State(initialValue: isJoined)
        self.isJoinedInitial = isJoined
        self._showPopup = showPopup
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { showPopup = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.gray)
                    Text("시작: \(schedule.startTime)")
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.gray)
                    Text("종료: \(schedule.endTime)")
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
                Text(schedule.title)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text("❌ \(errorMessage)").foregroundColor(.red).padding(.top, 5)
            }

            if isJoined {
                Text("✅ 이미 참석한 일정입니다")
                    .foregroundColor(.green)
                    .bold()
            }

            Button(action: {
                Task {
                    await handleJoin()
                }
            }) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text(isJoined ? "이미 참석됨" : "참석")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(isJoined ? Color.gray.opacity(0.4)
                                  : Color.gray)              
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(isJoined || isLoading)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding().alert("게스트로 참석하시겠습니까?", isPresented: $showGuestJoinAlert) {
            Button("예", role: .none) {
                Task {
                    await handleGuestJoin()
                }
            }
            Button("아니오", role: .cancel) {}
        } message: {
            Text("현재 클럽에 가입되어 있지 않거나 유효하지 않은 요청입니다.")
        }
    }
    func handleJoin() async {
        guard let userId = AppState.shared.user?.id else {
            errorMessage = "로그인이 필요합니다"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let _ = try await ParticipantAPI.join(userId: Int(userId)!, eventId: schedule.eventId)
            isJoined = true
        } catch {
            print("[ScheduleCheckPopup] ❌ 참가 실패: \(error.localizedDescription)")

            // 상태코드 확인
            if let afError = error as? AFError,
               let responseCode = afError.responseCode {
                switch responseCode {
                case 404:
                    showGuestJoinAlert = true // ✅ 팝업 띄우기
                default:
                    errorMessage = "서버 오류: \(responseCode)"
                }
            } else {
                errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
            }
        }

        isLoading = false
    }
    
    func handleGuestJoin() async {
        guard let userId = AppState.shared.user?.id else {
            errorMessage = "로그인이 필요합니다"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let _ = try await ParticipantAPI.joinclubByGuest(userId: Int(userId)!, eventId: schedule.eventId)
            isJoined = true
        } catch {
            errorMessage = "게스트 참석 실패: \(error.localizedDescription)"
            print("[ScheduleCheckPopup] ❌ 게스트 참석 실패: \(error)")
        }

        isLoading = false
    }

//    // ✅ 서버로 참가 요청
//    func handleJoin() async {
//        guard let userId = AppState.shared.user?.id else {
//            errorMessage = "로그인이 필요합니다"
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            let _ = try await ParticipantAPI.join(userId: Int(userId)!, eventId: schedule.eventId)
//            isJoined = true
//        } catch {
//            errorMessage = "서버 요청 실패: \(error.localizedDescription)"
//            print(error.localizedDescription)
//        }
//
//        isLoading = false
//    }
}
struct ScheduleCheckPopupWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCheckPopupWrapper(
            event: Event(
                eventId: 1,
                clubId: 1,
                startTime: Date(),
                endTime: Date().addingTimeInterval(3600),
                description: "더미 일정입니다"
            ),
            showPopup: .constant(true)
        )
    }
}
