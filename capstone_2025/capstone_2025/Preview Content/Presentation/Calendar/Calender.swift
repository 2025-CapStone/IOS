import SwiftUI

// MARK: - 모델 ----------------------------------------------------------------
struct Schedule: Identifiable {
    let id = UUID()
    let eventId: Int
    let startDate: String
    let endDate : String
    let startTime: String
    let endTime: String
    let title: String
}

// MARK: - MainCalendarView ----------------------------------------------------


struct MainCalendarView: View {
    var clubId: Int?
    var clubName: String? = ClubEventContext.shared.selectedClubName
    @ObservedObject var viewModel: EventListViewModel

    @State private var showSelectedScheduleListView = false
    @State private var showCreateTaskView = false
    @State private var showScheduleListView = false
    @State private var showPopup = false
    @State private var selectedDate = Date()
    @State private var selectedEvent: Event? = nil
    @State private var selectedOption: FilterOption = .selectedClub

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // ✅ 헤더
                HStack {
                    Image("ball").resizable().scaledToFit()
                        .frame(width: 32, height: 32)
                        .onTapGesture {
                            NavigationRouter().path.append(AppRoute.home)
                        }
                    Spacer()
                    Button(action: { /* 메뉴 토글 생략 */ }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // ✅ 라디오 버튼
                RadioButtonGroup { old, new in
                    selectedOption = new
                    switch new {
                    case .selectedClub:
                        if let cid = ClubEventContext.shared.selectedClubId {
                            viewModel.fetchClubEvents(for: cid)
                        }
                    case .joinedClubs:
                        viewModel.fetchClubUserEvents()
                    case .checkedEvents:
                        viewModel.fetchUserEvents()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // ✅ 선택한 클럽 이름
                if selectedOption == .selectedClub, let name = clubName {
                    Text(name)
                        .font(.title).bold()
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom,-30) // 👈 CalendarView와 자연스러운 간격
                }

                // ✅ CalendarView + SelectedScheduleListView
                VStack() {
                    CalendarView(
                        selectedDate: $selectedDate,
                        showPopup: $showPopup,
                        showCreateTaskView: $showCreateTaskView,
                        showScheduleListView: $showScheduleListView, showSelectedScheduleListView: $showSelectedScheduleListView,
                        events: viewModel.events
                    )
                    .blur(radius: showCreateTaskView ? 5 : 0)
                    .disabled(showCreateTaskView)

                  if showSelectedScheduleListView {
                        SelectedScheduleListView(
                            events: viewModel.events,
                            selectedDate: selectedDate,
                            selectedEvent: $selectedEvent,
                            showPopup: $showPopup
                        )
                    } else {
                        Text("일정이 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }

                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            if showScheduleListView {
                Color.white.opacity(0.9).ignoresSafeArea()
                    .onTapGesture { showScheduleListView = false }
                ScheduleListView(
                    showScheduleListView: $showScheduleListView,
                    selectedDate: selectedDate,
                    events: viewModel.events
                )
                .layoutPriority(0)
                .background(Color.white)
            }
        

            // ✅ 팝업
            if showPopup, let selected = selectedEvent {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .onTapGesture { showPopup = false }

                ScheduleCheckPopupWrapper(event: selected, showPopup: $showPopup)
                    .transition(.scale)
            }

            if showCreateTaskView {
                CreateTaskView(
                    showCreateTaskView: $showCreateTaskView,
                    selectedDate: selectedDate
                )
                .environmentObject(viewModel)
            }
        }
        .onAppear {
            if let cid = ClubEventContext.shared.selectedClubId {
                viewModel.fetchClubEvents(for: cid)
            }
        }
    }
}
//struct MainCalendarView: View {
//    var clubId: Int?
//    var clubName: String? = ClubEventContext.shared.selectedClubName
//    @ObservedObject var viewModel: EventListViewModel
//
//    @State private var showCreateTaskView = false
//    @State private var showScheduleListView = false
//    @State private var showPopup = false
//    @State private var selectedDate = Date()
//    @State private var selectedEvent: Event? = nil
//    @State private var selectedOption: FilterOption = .selectedClub
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 10) {
//                RadioButtonGroup { old, new in
//                    selectedOption = new
//                    switch new {
//                    case .selectedClub:
//                        if let cid = ClubEventContext.shared.selectedClubId {
//                            viewModel.fetchClubEvents(for: cid)
//                        }
//                    case .joinedClubs:
//                        viewModel.fetchClubUserEvents()
//                    case .checkedEvents:
//                        viewModel.fetchUserEvents()
//                    }
//                }
//
//                if selectedOption == .selectedClub, let name = clubName {
//                    Text(name)
//                        .font(.title).bold()
//                        .padding(.top, -20)
//                }
//
//                CalendarView(
//                    selectedDate: $selectedDate,
//                    showPopup: $showPopup,
//                    showCreateTaskView: $showCreateTaskView,
//                    showScheduleListView: $showScheduleListView,
//                    events: viewModel.events // ✅ 전달
//                )
//                .blur(radius: showCreateTaskView || showScheduleListView ? 5 : 0)
//                .disabled(showCreateTaskView || showScheduleListView)
//
//                // ✅ 일정 리스트 또는 "일정 없음" 메시지
//                if showScheduleListView {
//                    SelectedScheduleListView(
//                        events: viewModel.events,
//                        selectedDate: selectedDate,
//                        selectedEvent: $selectedEvent,
//                        showPopup: $showPopup
//                    )
//                    .background(Color.white)
//                }
//            }
//
//            // ✅ 팝업
//            if showPopup, let selected = selectedEvent {
//                Color.black.opacity(0.4).ignoresSafeArea()
//                    .onTapGesture { showPopup = false }
//
//                ScheduleCheckPopupWrapper(event: selected, showPopup: $showPopup)
//                    .transition(.scale)
//            }
//
//            if showCreateTaskView {
//                CreateTaskView(
//                    showCreateTaskView: $showCreateTaskView,
//                    selectedDate: selectedDate
//                )
//                .environmentObject(viewModel)
//            }
//        }
//        .onAppear {
//            if let cid = ClubEventContext.shared.selectedClubId {
//                viewModel.fetchClubEvents(for: cid)
//            }
//        }
//    }
//}

//struct MainCalendarView: View {
//    var clubId: Int?
//    var clubName: String? = ClubEventContext.shared.selectedClubName
//    @ObservedObject var viewModel: EventListViewModel
//    
//    @State private var showCreateTaskView = false
//    @State private var showScheduleListView = false
//    @State private var showPopup = false
//    @State private var selectedDate = Date()
//    
//    @State private var selectedOption: FilterOption = .selectedClub
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 10) {
//                // ✅ 필터 라디오 버튼
//                RadioButtonGroup { old, new in
//                    selectedOption = new
//                    switch new {
//                    case .selectedClub:
//                        if let cid = ClubEventContext.shared.selectedClubId {
//                            viewModel.fetchClubEvents(for: cid)
//                        }
//                    case .joinedClubs:
//                        viewModel.fetchClubUserEvents()
//                    case .checkedEvents:
//                        viewModel.fetchUserEvents()
//                    }
//                }
//                
//                // ✅ 클럽 이름 (selectedClub일 때만)
//                if selectedOption == .selectedClub, let name = clubName {
//                    Text(name)
//                        .font(.title).bold()
//                        .padding(.top, -20)
//                }
//                
//                // ✅ 달력 뷰
//                CalendarView(
//                    selectedDate: $selectedDate,
//                    showPopup: $showPopup,
//                    showCreateTaskView: $showCreateTaskView,
//                    showScheduleListView: $showScheduleListView
//                )
//                .blur(radius: showCreateTaskView || showScheduleListView ? 5 : 0)
//                .disabled(showCreateTaskView || showScheduleListView)
//            }
//            
//            // ✅ 팝업 뷰
//            if showPopup {
//                Color.black.opacity(0.3).ignoresSafeArea()
//                    .onTapGesture { showPopup = false }
//                EventPopupView(
//                    showPopup: $showPopup,
//                    showCreateTaskView: $showCreateTaskView,
//                    showScheduleListView: $showScheduleListView
//                )
//                .transition(.scale)
//            }
//            
//            // ✅ 일정 생성 뷰
//            if showCreateTaskView {
//                CreateTaskView(
//                    showCreateTaskView: $showCreateTaskView,
//                    selectedDate: selectedDate
//                )
//                .environmentObject(viewModel)
//            }
//            
//            // ✅ 일정 리스트 뷰
//            else if showScheduleListView {
//                Color.white.opacity(0.9).ignoresSafeArea()
//                    .onTapGesture { showScheduleListView = false }
//                ScheduleListView(
//                    showScheduleListView: $showScheduleListView,
//                    selectedDate: selectedDate,
//                    events: viewModel.events
//                )
//                .layoutPriority(0)
//                .background(Color.white)
//            }
//        }
//        .onAppear {
//            if let cid = ClubEventContext.shared.selectedClubId {
//                viewModel.fetchClubEvents(for: cid)
//            }
//        }
//    }
//}
// MARK: - CalendarView (달력 + 사이드 메뉴 + 접근 제한 팝업) --------------------
struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showPopup: Bool
    @Binding var showCreateTaskView: Bool
    @Binding var showScheduleListView: Bool
    //@Binding var showPopup : Bool
    @Binding var showSelectedScheduleListView : Bool
    @State private var month = Date()
    @EnvironmentObject private var router: NavigationRouter
    
  
    var events: [Event]  // ✅ 추가
    
    var body: some View {
        ZStack {
            // ── 달력 본문 ───────────────────────────────────
            VStack{VStack {
                //header
                Spacer(minLength: 10)
                monthHeader
                calendarGrid
                Spacer()
            }.layoutPriority(0)}
            
       
            
        }
    }
    
    

    
    // MARK: 월 표시
    private var monthHeader: some View {
//        @Binding var showPopup: Bool
//        @Binding var showCreateTaskView: Bool
//        @Binding var showScheduleListView: Bool

        VStack {
            
            HStack{
                Button {  } label: {
                    
                }
                Spacer()
                Text(dateString(selectedDate, ""))
                    .font(.title).bold().padding(.bottom, 10)
                Spacer()
                Button {                         showPopup = false; showScheduleListView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showCreateTaskView = true } } label: {
                            Image(systemName: "plus").bold().foregroundColor(.green)
                }
                
                
            }.padding(.horizontal, 40).padding(.vertical, 10)
            HStack {
                Button { addMonth(-1) } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(dateString(month, "MMMM yyyy"))
                Spacer()
                Button { addMonth(1) } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title2).foregroundColor(.black)
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
        }
    }
    private var calendarGrid: some View {
        let total = Calendar.current.range(of: .day, in: .month, for: month)!.count
        let first = firstWeekday(of: month) - 1

        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
            ForEach(0..<42) { idx in
                if idx < first || idx >= first + total {
                    Color.clear.frame(width: 40, height: 40)
                } else {
                    let day = idx - first + 1
                    if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth(month)) {
                        let sel = Calendar.current.isDate(selectedDate, inSameDayAs: date)
                        let hasEvent = events.contains { Calendar.current.isDate($0.startTime, inSameDayAs: date) }

                        CellView(day: day, isSelected: sel, hasEvent: hasEvent)
                            .onTapGesture {
                                selectedDate = date
                                showSelectedScheduleListView = true
                                //showScheduleListView = false
                            }.onLongPressGesture{
                                showScheduleListView = true
                                //showSelectedScheduleListView=false
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
//    // MARK: 날짜 그리드
//    private var calendarGrid: some View {
//        let total = Calendar.current.range(of: .day, in: .month, for: month)!.count
//        let first = firstWeekday(of: month) - 1
//        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
//            ForEach(0..<42) { idx in
//                if idx < first || idx >= first + total {
//                    Color.clear.frame(width: 40, height: 40)
//                } else {
//                    let day = idx - first + 1
//                    if let date = Calendar.current.date(byAdding: .day, value: day - 1,
//                                                        to: startOfMonth(month)) {
//                        let sel = Calendar.current.isDate(selectedDate, inSameDayAs: date)
//                        CellView(day: day, isSelected: sel)
//                            .onTapGesture {
//                                print("qqqq")
//                                selectedDate = date
//                                //showPopup    = true
//                                showScheduleListView = true
//                            }
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 10)
//    }
    
    // 날짜 유틸
    private func firstWeekday(of d: Date) -> Int {
        Calendar.current.component(.weekday, from: startOfMonth(d))
    }
    private func startOfMonth(_ d: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: d))!
    }
    private func addMonth(_ v: Int) {
        if let next = Calendar.current.date(byAdding: .month, value: v, to: month) {
            month = next; selectedDate = next
        }
    }
    private func dateString(_ d: Date, _ f: String) -> String {
        let df = DateFormatter(); df.dateFormat = f; return df.string(from: d)
    }
}

// MARK: - CellView ------------------------------------------------------------
//struct CellView: View {
//    let day: Int; let isSelected: Bool
//    var body: some View {
//        Text("\(day)").foregroundColor(Color.gray)
//            .frame(width: 45, height: 45)
//            .background(
//                Circle().fill(isSelected ? Color.green : Color.green.opacity(0.1))
//                    .overlay(Circle().stroke(isSelected ? .green : .clear,
//                                             lineWidth: 2))
//            )
//            .font(.title3)
//            .foregroundColor(isSelected ? .white : .black)
//    }
//}
struct CellView: View {
    let day: Int
    let isSelected: Bool
    let hasEvent: Bool

    var body: some View {
        VStack(spacing: 4) {
            if hasEvent {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
            }
            Text("\(day)")
                .frame(width: 45, height: 45)
                .background(
                    Circle().fill(isSelected ? Color.green : Color.green.opacity(0.1))
                        .overlay(Circle().stroke(isSelected ? .green : .clear, lineWidth: 2))
                )
                .font(.title3)
                .foregroundColor(isSelected ? .white : .black)
        }
    }
}





// MARK: - Dummy ViewModel for preview -----------------------------------------
extension EventListViewModel {
    static func dummy() -> EventListViewModel {
        let vm = EventListViewModel()
        vm.events = [
            Event(eventId: 1, clubId: 1, startTime: Date(),
                  endTime: Date().addingTimeInterval(3600), description: "더미 1"),
            Event(eventId: 2, clubId: 1, startTime: Date(),
                  endTime: Date().addingTimeInterval(7200), description: "더미 2")
        ]
        return vm
    }
}

struct MainCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalendarView(
            clubId: 1,
            clubName: "Swift 클럽",
            viewModel: previewViewModel
        )
        .environmentObject(NavigationRouter())
    }

    static var previewViewModel: EventListViewModel {
        let vm = EventListViewModel()
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!

        vm.events = [
            Event(
                eventId: 1,
                clubId: 1,
                startTime: now,
                endTime: Calendar.current.date(byAdding: .hour, value: 2, to: now)!,
                description: "프리뷰 이벤트 - 오늘"
            ),
            Event(
                eventId: 2,
                clubId: 1,
                startTime: tomorrow,
                endTime: Calendar.current.date(byAdding: .hour, value: 3, to: tomorrow)!,
                description: "프리뷰 이벤트 - 내일"
            )
        ]
        return vm
    }
}
