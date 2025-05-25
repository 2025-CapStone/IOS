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
    
    @State private var selectedClubName: String = ""
    @State private var descriptionText: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    
    @State private var showSuccessAlert = false

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
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)

            // 🔸 일정 설명 입력
            TextField("일정 설명을 입력하세요", text: $descriptionText)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .font(.body)
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

            // 🔸 소속 클럽 선택
            Picker("소속 클럽 선택", selection: $selectedClubName) {
                ForEach(AppState.shared.user!.joinedClub.map(\ .clubName!), id: \ .self) { clubName in
                    Text(clubName).tag(clubName)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)
            .padding(.horizontal)

            // 🔘 생성 버튼
            Button(action: {
                let mergedStart = merge(date: selectedDate, time: startTime)
                let mergedEnd = merge(date: selectedDate, time: endTime)

                guard let userClub = AppState.shared.user!.joinedClub.first(where: { $0.clubName == selectedClubName }) else { return }

                viewModel.setClubId(userClub.clubId!)
                viewModel.createEvent(
                    startTime: mergedStart,
                    endTime: mergedEnd,
                    description: descriptionText
                ) { success in
                    if success {
                        showSuccessAlert = true
                    } else {
                        print("[CreateTaskView] ❌ 이벤트 생성 실패")
                    }
                }
            }) {
                Text("일정 생성")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .font(.headline)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .alert("일정이 생성되었습니다", isPresented: $showSuccessAlert) {
            Button("확인") {
                showCreateTaskView = false
            }
        }
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

// MARK: - Preview 용 더미 ViewModel
class DummyEventListViewModel: ObservableObject {
    @Published var events: [Event] = []

    init() {
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

// MARK: - CreateTaskView 미리보기
struct CreateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTaskView(
            showCreateTaskView: .constant(true),
            selectedDate: Date()
        )
        .environmentObject(DummyEventListViewModel())
    }
}
