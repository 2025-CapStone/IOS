//
//  ScheduleListView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//
import SwiftUI


struct ScheduleListView: View {
    @Binding var showScheduleListView: Bool
    var selectedDate: Date
    var events: [Event]

    @State private var selectedSchedule: Event? = nil
    @State private var showPopup = false

    var filteredEvents: [Event] {
        events.filter { Calendar.current.isDate($0.startTime, inSameDayAs: selectedDate) }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                 
                    Button(action: { showScheduleListView = false }) {
                        Image(systemName: "arrow.left")
                    }
                }
                .padding(.horizontal)

                Text(formattedDate(selectedDate))
                    .font(.title2)
                    .bold()

                ScrollView {
                    if filteredEvents.isEmpty {
                        Text("해당 날짜에 일정이 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.top, 60)
                    } else {
                        ForEach(filteredEvents) { event in
                            Button(action: {
                                selectedSchedule = event
                                showPopup = true
                            }) {
                                VStack(alignment: .leading) {
                                    Text(event.startTime.formatted(date: .omitted, time: .shortened))
                                        .foregroundColor(.brown)
                                    Text(event.description)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }

            // ✅ 팝업이 있을 경우 어두운 배경 + 팝업 표시
            if let event = selectedSchedule, showPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPopup = false
                    }

//                ScheduleCheckPopup(
//                    schedule: Schedule(
//                        eventId: event.eventId,
//                        startTime: event.startTime.formatted(date: .omitted, time: .shortened), endTime: event.endTime.formatted(date: .omitted, time: .shortened),
//                        title: event.description
//                    ),
//                    showPopup: $showPopup
//                )
                ScheduleCheckPopupWrapper(
                    event: event,
                    showPopup: $showPopup
                )
                .zIndex(1)
                .transition(.scale)
                .animation(.easeInOut, value: showPopup)
            }
        }
        .onAppear {
            print("[ScheduleListView] ✅ onAppear 호출됨")
//            if let clubId = ClubEventContext.shared.selectedClubId {
//                // 최신 이벤트 목록 요청
//                EventListViewModel().fetchEvents(for: clubId)
//            }
        }
        .onDisappear {
            print("[ScheduleListView] ✅ onDisappear 호출됨")
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}

// ✅ 날짜 포맷 함수
private func formattedYearMonth(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    return formatter.string(from: date)
}


// 5/10 프리뷰 부분

struct ScheduleListView_Previews: PreviewProvider {
    @State static var showScheduleListView = true

    static var previews: some View {
        ScheduleListView(
            showScheduleListView: $showScheduleListView,
            selectedDate: Date(),
            events: dummyEvents
        )
    }

    static var dummyEvents: [Event] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        return [
            Event(
                eventId: 1,
                clubId: 1,
                startTime: formatter.date(from: "2025-05-10T10:00:00Z")!,
                endTime: formatter.date(from: "2025-05-10T12:00:00Z")!,
                description: "더미 이벤트 A"
            ),
            Event(
                eventId: 2,
                clubId: 1,
                startTime: formatter.date(from: "2025-05-10T15:00:00Z")!,
                endTime: formatter.date(from: "2025-05-10T16:30:00Z")!,
                description: "더미 이벤트 B"
            )
        ]
    }
}
