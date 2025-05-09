import SwiftUI


struct Schedule: Identifiable {
    let id = UUID()
    let time: String
    let title: String
}

struct MainCalendarView: View {
    //@StateObject private var viewModel = EventListViewModel()
    var clubId: Int?
    @ObservedObject var viewModel: EventListViewModel // ✅ 여기만 수정

    @State private var showCreateTaskView = false
    @State private var showScheduleListView = false
    @State private var showPopup = false
    @State private var selectedDate: Date = Date()

    var body: some View {
        ZStack {
            CalendarView(selectedDate: $selectedDate, showPopup: $showPopup)

            if showPopup {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture { showPopup = false }

                EventPopupView(
                    showPopup: $showPopup,
                    showCreateTaskView: $showCreateTaskView,
                    showScheduleListView: $showScheduleListView
                )
                .transition(.scale)
            }
            if showCreateTaskView {
                CreateTaskView(showCreateTaskView: $showCreateTaskView, selectedDate: selectedDate)
                    .environmentObject(viewModel).onTapGesture{"ShowCreateTaskView tapped"} // ✅ 주입
                
            }
            
//            if showCreateTaskView {
//                CreateTaskView(showCreateTaskView: $showCreateTaskView, selectedDate: selectedDate)
//            }

            else if showScheduleListView {
                ScheduleListView(showScheduleListView: $showScheduleListView, selectedDate: selectedDate, events: viewModel.events).onTapGesture{"showSchedulistView tapped"}
            }
        }
        .onAppear {                       if let clubId = ClubEventContext.shared.selectedClubId {
            viewModel.setClubId(clubId)
            viewModel.fetchEvents(for: clubId)
        }}
    }
}


struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showPopup: Bool
    @State private var month: Date = Date()
    @EnvironmentObject var router : NavigationRouter // ✅ 네비게이션 상태 객체 선언
    @State private var isMenuOpen = false



    var body: some View {
        VStack {
            // 🔹 네비게이션 바
            HStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .onTapGesture{router.path.append(AppRoute.home)}

                Spacer()
                
                // ✅ 메뉴 버튼
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image("menu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

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
        if isMenuOpen {
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        MenuItem(title: "일정관리").onTapGesture{
                           print("일정관리 탭제스쳐")
                        }
                        MenuItem(title: "회원관리").onTapGesture {
                            print("회원관리 탭제스쳐")

                        }
                        MenuItem(title: "예산관리").onTapGesture {
                         
                        }
                        Divider()
                        // ✅ 로그아웃 버튼 수정
                        MenuItem(title : "로그아웃")
                   
                    }
                    .frame(width: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 50)
                    .padding(.trailing, 10)
                }
                Spacer()
            }
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
            .onTapGesture {
                withAnimation {
                    isMenuOpen = false
                }
            }
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
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 10)

            VStack(spacing: 16) {
                HStack {
                    // 왼쪽 상단 아이콘
                    HStack(spacing: 4) {
                    
                        Image("logo").resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    .font(.title3)
                    .foregroundColor(.black)

                    Spacer()

                    // 오른쪽 상단 화살표
                    Button(action: { showPopup = false }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.horizontal)

                Spacer()

                // 버튼 2개
                HStack(spacing: 20) {
                    Button(action: {
                        showPopup = false
                        showScheduleListView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCreateTaskView = true
                            }
                       
                    }) {
                        Text("일정 생성")
                            .frame(width: 120, height: 40)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showPopup = false
                        //showScheduleListView = true
                        showCreateTaskView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showScheduleListView = true
                            }
                    }) {
                        Text("일정 확인 / 출첵")
                            .frame(width: 120, height: 40)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.top, 16)
            .frame(width: 300, height: 150)
        }
        .frame(width: 300, height: 150)
    }
}


struct CreateTaskView: View {
    @Binding var showCreateTaskView: Bool
    var selectedDate: Date

    @State private var name: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var detail: String = ""
    @State private var category: String = ""
    @State private var longDetail: String = ""

    @EnvironmentObject var viewModel: EventListViewModel  // ✅ ViewModel 주입

    let categories = ["운영진", "정회원", "휴회원", "기타"]

    var body: some View {
        VStack(spacing: 20) {
            // 상단 바
            HStack {
                Button(action: { showCreateTaskView = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)

            // Name
            TextField("Name", text: $name)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .padding(.horizontal)

            // Start Time & End Time
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

            // One-line Details
            TextField("Details", text: $detail)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .padding(.horizontal)

            // Task Category Picker
            Picker(selection: $category, label: Text(category.isEmpty ? "참여 등급" : category)) {
                Text("참여 등급").tag("")
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            .padding(.horizontal)

            // Multi-line Details
            TextEditor(text: $longDetail)
                .frame(height: 100)
                .padding(8)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .padding(.horizontal)

            // ✅ Create 버튼: 이벤트 생성 호출
            Button(action: {
                let mergedStart = merge(date: selectedDate, time: startTime)
                let mergedEnd = merge(date: selectedDate, time: endTime)

                viewModel.createEvent(
                    startTime: mergedStart,
                    endTime: mergedEnd,
                    description: detail
                ) { success in
                    if success {
                        // 5/9 요청 사항 팝업 생성
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
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.year, .month, .day], from: date)
        let timeComponents = cal.dateComponents([.hour, .minute], from: time)

        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute

        return cal.date(from: merged) ?? date
    }
}



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
                    Image("ball").resizable().frame(width: 24, height: 24)
                    Spacer()
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

                ScheduleCheckPopup(
                    schedule: Schedule(
                        time: event.startTime.formatted(date: .omitted, time: .shortened),
                        title: event.description
                    ),
                    showPopup: $showPopup
                )
                .zIndex(1)
                .transition(.scale)
                .animation(.easeInOut, value: showPopup)
            }
        }
        .onAppear {
            print("[ScheduleListView] ✅ onAppear 호출됨")
            if let clubId = ClubEventContext.shared.selectedClubId {
                // 최신 이벤트 목록 요청
                EventListViewModel().fetchEvents(for: clubId)
            }
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
import SwiftUI

struct ScheduleCheckPopup: View {
    let schedule: Schedule
    @Binding var showPopup: Bool

    var body: some View {
        VStack(spacing: 16) {
            // 상단 아이콘 및 닫기
            HStack {
                Image("logo")
                Spacer()
                Button(action: { showPopup = false }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)

            // 클릭한 일정의 시간과 제목 표시
            VStack(spacing: 4) {
                Text(schedule.title)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)

            // 입력 필드들 (비활성화된 상태)
            VStack(spacing: 12) {
                TextField("Name", text: .constant(""))
                    .disabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "flag.fill")
                        Text(schedule.time)
                        Spacer()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                    HStack {
                        Image(systemName: "play.fill")
                        Text("End Time")
                        Spacer()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }

                TextField("Details", text: .constant(""))
                    .disabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                TextField("Details", text: .constant(""))
                    .disabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            }
            .padding(.horizontal)

            // 위치 아이콘
            HStack {
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            // 참석 버튼
            Button(action: {
                // 출석 처리 로직 추가 가능
            }) {
                Text("참석")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.top)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .onAppear {
            print("[ScheduleCheckPopup] ✅ 팝업 등장")
        }
        .onDisappear {
            print("[ScheduleCheckPopup] ✅ 팝업 닫힘")
        }
    }
}
