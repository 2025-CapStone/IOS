//
//  CreateTaskView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/10/25.
//

import SwiftUI

struct CreateTaskView: View {
    @Binding var showCreateTaskView: Bool
    var selectedDate: Date

    @State private var descriptionText: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var longDetail: String = ""

    @EnvironmentObject var viewModel: EventListViewModel

    var body: some View {
        VStack(spacing: 20) {
            // 🔺 상단 바
            HStack {
                Button(action: { showCreateTaskView = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)

            // 🔹 선택된 날짜 중앙 표시
            Text(formattedDate(selectedDate))
                .font(.headline)
                .padding(.bottom, 10)

            // 🔸 일정 설명 입력
            TextField("Description", text: $descriptionText)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .padding(.horizontal)

            // 🔸 시작 및 종료 시간 선택
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.gray)
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.gray)
                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
            .padding(.horizontal)

            // 🔸 상세 내용 입력
            TextEditor(text: $longDetail)
                .frame(height: 100)
                .padding(8)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .padding(.horizontal)

            // 🔘 생성 버튼
            Button(action: {
                let mergedStart = merge(date: selectedDate, time: startTime)
                let mergedEnd = merge(date: selectedDate, time: endTime)

                viewModel.createEvent(
                    startTime: mergedStart,
                    endTime: mergedEnd,
                    description: descriptionText
                ) { success in
                    if success {
                        showCreateTaskView = false
                    } else {
                        print("[CreateTaskView] ❌ 이벤트 생성 실패")
                    }
                }
            }) {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }

    // ✅ 날짜 + 시간 병합
    func merge(date: Date, time: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)

        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        return Calendar.current.date(from: components) ?? date
    }

    // ✅ 날짜 포맷 함수
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}




let dummyViewModel = DummyEventListViewModel()
#Preview {
    CreateTaskView(
        showCreateTaskView: .constant(true),
        selectedDate: Date()
    )
    .environmentObject(dummyViewModel)
}
 class DummyEventListViewModel: ObservableObject {
    @Published var events: [Event] = []

    init() {
        // 테스트용 이벤트 더미 데이터
        events = [
            Event(eventId: 1, clubId: 1, startTime: Date(), endTime: Date().addingTimeInterval(3600), description: "더미 일정 1"),
            Event(eventId: 2, clubId: 1, startTime: Date(), endTime: Date().addingTimeInterval(7200), description: "더미 일정 2")
        ]
    }

    func setClubId(_ id: Int) { }
    func fetchEvents(for clubId: Int) { }
    func createEvent(startTime: Date, endTime: Date, description: String, completion: @escaping (Bool) -> Void) {
        print("[DummyEventListViewModel] createEvent 호출됨")
        completion(true)
    }
}
