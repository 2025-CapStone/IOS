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
                // ✅ 상단 바
                HStack {
                    Button(action: { showScheduleListView = false }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                // ✅ 선택 날짜
                Text(formattedDate(selectedDate))
                    .font(.title2)
                    .bold()

                // ✅ 일정 목록
                ScrollView {
                    if filteredEvents.isEmpty {
                        Text("해당 날짜에 일정이 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.top, 60)
                    } else {
                        ForEach(filteredEvents) { event in
                            Button {
                                selectedSchedule = event
                                showPopup = true
                            } label: {
                                ScheduleListViewCell(event: event)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }

            // ✅ 팝업
            if let event = selectedSchedule, showPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPopup = false
                    }

                ScheduleCheckPopupWrapper(event: event, showPopup: $showPopup)
                    .zIndex(1)
                    .transition(.scale)
                    .animation(.easeInOut, value: showPopup)
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    @State static var showScheduleListView = true

    static var previews: some View {
        ScheduleListView(
            showScheduleListView: $showScheduleListView,
            selectedDate: Date(),
            events: dummyEvents
        )
        .previewDisplayName("Schedule List View")
    }

    static var dummyEvents: [Event] {
        let now = Date()
        let calendar = Calendar.current
        let todayMorning = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!
        let todayNoon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
        let todayEvening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!

        return [
            Event(
                eventId: 1,
                clubId: 1,
                startTime: todayMorning,
                endTime: calendar.date(byAdding: .hour, value: 1, to: todayMorning)!,
                description: "아침 운동 모임"
            ),
            Event(
                eventId: 2,
                clubId: 1,
                startTime: todayNoon,
                endTime: calendar.date(byAdding: .hour, value: 1, to: todayNoon)!,
                description: "점심 간단 회의"
            ),
            Event(
                eventId: 3,
                clubId: 1,
                startTime: todayEvening,
                endTime: calendar.date(byAdding: .hour, value: 2, to: todayEvening)!,
                description: "저녁 테니스 연습"
            )
        ]
    }
}
