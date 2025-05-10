import SwiftUI


struct Schedule: Identifiable {
    let id = UUID()
    let eventId : Int
    let startTime: String
    let endTime: String // 🔹 추가
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
                .blur(radius: showCreateTaskView || showScheduleListView ? 5 : 0)
                .disabled(showCreateTaskView || showScheduleListView)

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



// 메인 칼랜더 프리뷰 부분 5/10

extension MainCalendarView {
    init(
        clubId: Int?,
        viewModel: EventListViewModel,
        showCreateTaskView: Bool = false,
        showScheduleListView: Bool = false
    ) {
        self.clubId = clubId
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._showCreateTaskView = State(initialValue: showCreateTaskView)
        self._showScheduleListView = State(initialValue: showScheduleListView)
        self._showPopup = State(initialValue: false)
        self._selectedDate = State(initialValue: Date())
    }
}

extension EventListViewModel {
    static func dummy() -> EventListViewModel {
        let vm = EventListViewModel()
        vm.events = [
            Event(eventId: 1, clubId: 1, startTime: Date(), endTime: Date().addingTimeInterval(3600), description: "더미 1"),
            Event(eventId: 2, clubId: 1, startTime: Date(), endTime: Date().addingTimeInterval(7200), description: "더미 2")
        ]
        return vm
    }
}
struct MainCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 기본 상태
            MainCalendarView(
                clubId: 1,
                viewModel: .dummy()
            )
            .previewDisplayName("기본 상태")

            // 일정 생성 화면이 활성화된 상태
            MainCalendarView(
                clubId: 1,
                viewModel: .dummy(),
                showCreateTaskView: true
            )
            .previewDisplayName("일정 생성 화면")

            // 일정 리스트 화면이 활성화된 상태
            MainCalendarView(
                clubId: 1,
                viewModel: .dummy(),
                showScheduleListView: true
            )
            .previewDisplayName("일정 리스트 화면")
        }
    }
}

