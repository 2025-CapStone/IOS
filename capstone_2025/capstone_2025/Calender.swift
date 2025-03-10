import SwiftUI

struct MainCalendarView: View {
    @State private var showCreateTaskView = false
    @State private var showScheduleListView = false
    @State private var showPopup = false
    @State private var selectedDate: Date = Date() // 기본 선택 날짜 (현재 년/월)

    var body: some View {
        ZStack {
            CalendarView(selectedDate: $selectedDate, showPopup: $showPopup)

            if showPopup {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showPopup = false }

                EventPopupView(
                    showPopup: $showPopup,
                    showCreateTaskView: $showCreateTaskView,
                    showScheduleListView: $showScheduleListView
                )
                .transition(.scale)
                .animation(.easeInOut, value: showPopup)
            }

            if showCreateTaskView {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                CreateTaskView(showCreateTaskView: $showCreateTaskView, selectedDate: selectedDate)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showCreateTaskView)
            }

            if showScheduleListView {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                ScheduleListView(showScheduleListView: $showScheduleListView, selectedDate: selectedDate)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showScheduleListView)
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showPopup: Bool
    @State private var month: Date = Date()
    @StateObject var router = NavigationRouter() // ✅ 네비게이션 상태 객체 생성


    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: club_create()) {
                    Image(systemName: "plus") // 우측 상단 추가 버튼
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }

                Button(action: { print("특정 화면 이동")
                    router.path = NavigationPath()
                    router.path.append(AppRoute.home)
                }) {
                    Image(systemName: "person.3.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                Button(action: { print("뒤로 가기")
                    router.path = NavigationPath()
                    router.path.removeLast()
                }) {
                    
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer(minLength: 10)

            Text(formattedYearMonth(selectedDate))
                .font(.title2)
                .bold()
                .padding(.bottom, 10)

            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text(month, formatter: CalendarView.dateFormatter)
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 10)

            calendarGridView

            Spacer()
        }
    }

    // ✅ 날짜를 표시하는 `LazyVGrid`
    private var calendarGridView: some View {
        let daysInMonth = numberOfDays(in: month)
        let firstWeekday = firstWeekdayOfMonth(in: month) - 1

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .center), count: 7), spacing: 10) {
            ForEach(0..<42, id: \.self) { index in
                if index < firstWeekday || index >= firstWeekday + daysInMonth {
                    Color.clear.frame(width: 40, height: 40)
                } else {
                    let day = index - firstWeekday + 1
                    if let date = getDate(for: day) {
                        let isSelected = Calendar.current.isDate(selectedDate, inSameDayAs: date)

                        CellView(day: day, isSelected: isSelected)
                            .onTapGesture {
                                selectedDate = date
                                showPopup = true
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }

    // ✅ 날짜 관련 메서드 수정 및 복원
    private func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    private func firstWeekdayOfMonth(in date: Date) -> Int {
        let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        return Calendar.current.component(.weekday, from: firstDay)
    }

    // ✅ `getDate(for:)` 메서드 수정 (옵셔널 처리 추가)
    private func getDate(for day: Int) -> Date? {
        guard let date = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth()) else {
            return nil
        }
        return Calendar.current.startOfDay(for: date)
    }

    private func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }

    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            month = newMonth
            selectedDate = newMonth
        }
    }

    private func formattedYearMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.string(from: date)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

// ✅ 날짜를 표시하는 `CellView`
struct CellView: View {
    var day: Int
    var isSelected: Bool

    var body: some View {
        Text("\(day)")
            .frame(width: 45, height: 45)
            .background(
                Circle()
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.2))
                    .overlay(
                        Circle().stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
            )
            .font(.title3)
            .foregroundColor(isSelected ? .white : .black)
    }
}


// ✅ Event Popup View
struct EventPopupView: View {
    @Binding var showPopup: Bool
    @Binding var showCreateTaskView: Bool
    @Binding var showScheduleListView: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { showPopup = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)

            HStack(spacing: 20) {
                Button(action: {
                    showPopup = false
                    showCreateTaskView = true
                }) {
                    Text("일정 생성")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }

                Button(action: {
                    showPopup = false
                    showScheduleListView = true
                }) {
                    Text("일정 확인 / 출첵")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
            }
            .padding()
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

// ✅ Create Task View (일정 생성)
struct CreateTaskView: View {
    @Binding var showCreateTaskView: Bool
    var selectedDate: Date

    var body: some View {
        VStack {
            HStack {
                Button(action: { showCreateTaskView = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()

            Text("일정 생성")
                .font(.title2)
                .bold()

            Text(formattedYearMonth(selectedDate))
                .font(.title3)
                .bold()
                .padding(.bottom, 10)

            TextField("일정 제목", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: { showCreateTaskView = false }) {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

// ✅ Schedule List View (일정 확인 / 출첵)
struct ScheduleListView: View {
    @Binding var showScheduleListView: Bool
    var selectedDate: Date

    var body: some View {
        VStack {
            HStack {
                Button(action: { showScheduleListView = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()

            Text("일정 확인 / 출첵")
                .font(.title2)
                .bold()

            Text(formattedYearMonth(selectedDate))
                .font(.title3)
                .bold()
                .padding(.bottom, 10)

            ScrollView {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 80)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
            }

            Button(action: { showScheduleListView = false }) {
                Text("닫기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

// ✅ 날짜 포맷 함수
private func formattedYearMonth(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    return formatter.string(from: date)
}




// ✅ Preview
struct MainCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendarView()
    }
}


//CreateTaskView 에서 필요한 API

// 사용자가 소속된 동호회 명단,
// 일정 주최는 사용자가 운영자일때만 가능하게 할건지?
// 사용자는 일정을 생성할때 소속 동호회를 선택하는 UI가 필요
// 일정 생성시 등급별 참여 제한을 둘 수 있음
///api/event/add-event API 이용
