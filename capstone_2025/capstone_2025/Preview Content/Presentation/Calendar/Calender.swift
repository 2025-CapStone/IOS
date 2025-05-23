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
//
//struct MainCalendarView: View {
//    var clubId: Int?
//    var clubName: String? = ClubEventContext.shared.selectedClubName
//    @ObservedObject var viewModel: EventListViewModel
//
//    @State private var showSelectedScheduleListView = false
//    @State private var showCreateTaskView = false
//    @State private var showScheduleListView = false
//    @State private var showPopup = false
//    @State private var selectedDate = Date()
//    @State private var selectedEvent: Event? = nil
//    @State private var selectedOption: FilterOption = .selectedClub
//    @State private var disableSelectedClub: Bool = false
//
//    var body: some View {
//        ZStack {
//            VStack(spacing:0 ) {
//                // ✅ 헤더
//                HStack {
//                    Image("ball").resizable().scaledToFit()
//                        .frame(width: 32, height: 32)
//                        .onTapGesture {
//                            NavigationRouter().path.append(AppRoute.home)
//                        }
//                    Spacer()
//                    Button(action: {}) {
//                        Image(systemName: "ellipsis")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(.green)
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 40)
//
//                // ✅ 라디오 버튼
//                RadioButtonGroup(
//                    selectedOption: $selectedOption,
//                    disableSelectedClub: disableSelectedClub
//                ) { old, new in
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
//                .padding(.horizontal)
//                .padding(.top, 12)
//
//                if selectedOption == .selectedClub, let name = clubName {
//                    Text(name)
//                        .font(.title).bold()
//                        .padding(.horizontal)
//                        .padding(.top, 10)
//                        .padding(.bottom,-30)
//                }
//
//                VStack {
//                    CalendarView(
//                        selectedDate: $selectedDate,
//                        showPopup: $showPopup,
//                        showCreateTaskView: $showCreateTaskView,
//                        showScheduleListView: $showScheduleListView,
//                        showSelectedScheduleListView: $showSelectedScheduleListView,
//                        events: viewModel.events
//                    )
//                    .blur(radius: showCreateTaskView ? 5 : 0)
//                    .disabled(showCreateTaskView)
//
//                    if showSelectedScheduleListView {
//                        SelectedScheduleListView(
//                            events: viewModel.events,
//                            selectedDate: selectedDate,
//                            selectedEvent: $selectedEvent,
//                            showPopup: $showPopup
//                        )
//                    } else {
//                        Text("일정이 없습니다.")
//                            .foregroundColor(.gray)
//                            .padding(.top, 40)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom)
//            }
//
//            if showScheduleListView {
//                Color.white.opacity(0.9).ignoresSafeArea()
//                    .onTapGesture { showScheduleListView = false }
//
//                ScheduleListView(
//                    showScheduleListView: $showScheduleListView,
//                    selectedDate: selectedDate,
//                    events: viewModel.events
//                )
//                .layoutPriority(0)
//                .background(Color.white)
//            }
//
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
//            // ✅ 조건 판단: ClubId가 없으면 .joinedClubs으로 초기화
//            if let cid = ClubEventContext.shared.selectedClubId {
//                selectedOption = .selectedClub
//                disableSelectedClub = false
//                viewModel.fetchClubEvents(for: cid)
//            } else {
//                selectedOption = .joinedClubs
//                disableSelectedClub = true
//                viewModel.fetchClubUserEvents()
//            }
//        }
//    }
//}


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
    @State private var disableSelectedClub: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let totalHeight = geometry.size.height
            let totalWidth = geometry.size.width
            var calendarHeight = totalHeight * 0.15
            let calendarWidth = totalWidth*0.75
            let listHeight = totalHeight * 0.40
            let radioGroupWidth = totalWidth*0.90

            ZStack {
                VStack(spacing: 12) {
                    // Header
                    HStack {
                        Image("ball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                NavigationRouter().path.append(AppRoute.home)
                            }
                        Spacer()
                        if selectedOption == .selectedClub, let name = clubName {
                            Text(name)
                                .font(.title)
                                .padding(.horizontal)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    Spacer()
                    
                    VStack{
                        
                        // Filter
                        RadioButtonGroup(
                            selectedOption: $selectedOption,
                            disableSelectedClub: disableSelectedClub
                        ) { _, new in
                            selectedOption = new
                            switch new {
                            case .selectedClub:
                                calendarHeight = calendarHeight*0.20
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
                        
                    }.padding(.horizontal, 1).padding(.bottom,100).frame(width:radioGroupWidth)
                    Spacer()

                    VStack(spacing: 12) {
                        CalendarView(
                            selectedDate: $selectedDate,
                            showPopup: $showPopup,
                            showCreateTaskView: $showCreateTaskView,
                            showScheduleListView: $showScheduleListView,
                            showSelectedScheduleListView: $showSelectedScheduleListView,
                            events: viewModel.events
                        )
                        .frame(height: calendarHeight)
                        .blur(radius: showCreateTaskView ? 5 : 0)
                        .disabled(showCreateTaskView)

                        if showSelectedScheduleListView {
                            SelectedScheduleListView(
                                events: viewModel.events,
                                selectedDate: selectedDate,
                                selectedEvent: $selectedEvent,
                                showPopup: $showPopup
                            )
                            .frame(height: listHeight)
                        } else {
                            Text("일정이 없습니다.")
                                .foregroundColor(.gray)
                                .frame(height: listHeight)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }

                if showScheduleListView {
                    Color.white.opacity(0.9).ignoresSafeArea()
                        .onTapGesture { showScheduleListView = false }

                    ScheduleListView(
                        showScheduleListView: $showScheduleListView,
                        selectedDate: selectedDate,
                        events: viewModel.events
                    )
                    .background(Color.white)
                }

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
        }
        .onAppear {
            if let cid = ClubEventContext.shared.selectedClubId {
                selectedOption = .selectedClub
                disableSelectedClub = false
                viewModel.fetchClubEvents(for: cid)
            } else {
                selectedOption = .joinedClubs
                disableSelectedClub = true
                viewModel.fetchClubUserEvents()
            }
        }
    }
}

// MARK: - CalendarView (달력 + 사이드 메뉴 + 접근 제한 팝업) --------------------

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showPopup: Bool
    @Binding var showCreateTaskView: Bool
    @Binding var showScheduleListView: Bool
    @Binding var showSelectedScheduleListView: Bool
    @State private var month = Date()
    var events: [Event]

    var body: some View {
        VStack(spacing: 10) {
            monthHeader
            calendarGrid
        }
    }

    private var monthHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                Button { showPreviousMonth() } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(dateString(month, "MMMM yyyy"))
                    .font(.title3).bold().opacity(0.6)
                Spacer()
                Button { showNextMonth() } label: {
                    Image(systemName: "chevron.right")
                }
                Spacer()
            }

            HStack {
                Spacer()
                Button {
                    showPopup = false
                    showScheduleListView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showCreateTaskView = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
                .padding(.top, 4)
            }
            .padding(.trailing, 20)
        }
        .padding(.horizontal, 20)
    }

    private var calendarGrid: some View {
        let total = Calendar.current.range(of: .day, in: .month, for: month)!.count
        let first = firstWeekday(of: month) - 1

        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 6) {
            ForEach(0..<42) { idx in
                if idx < first || idx >= first + total {
                    Color.clear.frame(height: 40)
                } else {
                    let day = idx - first + 1
                    if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth(month)) {
                        let isSelected = Calendar.current.isDate(selectedDate, inSameDayAs: date)
                        let hasEvent = events.contains { Calendar.current.isDate($0.startTime, inSameDayAs: date) }
                        let state = cellState(isSelected: isSelected, hasEvent: hasEvent)

                        CellView(day: day, state: state)
                            .onTapGesture {
                                selectedDate = date
                                showSelectedScheduleListView = true
                            }
                            .onLongPressGesture {
                                showScheduleListView = true
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    // ✅ 상태 판별 함수
    private func cellState(isSelected: Bool, hasEvent: Bool) -> CellState {
        switch (isSelected, hasEvent) {
        case (true, _):         return .isSelected
        case (false, true):     return .hasEvent
        case (false, false):    return .isUnSelected
        }
    }

    private func showPreviousMonth() {
        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: month) {
            month = prev
            selectedDate = prev
        }
    }

    private func showNextMonth() {
        if let next = Calendar.current.date(byAdding: .month, value: 1, to: month) {
            month = next
            selectedDate = next
        }
    }

    private func startOfMonth(_ date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
    }

    private func firstWeekday(of date: Date) -> Int {
        Calendar.current.component(.weekday, from: startOfMonth(date))
    }

    private func dateString(_ date: Date, _ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

// MARK: - CellView ------------------------------------------------------------

// ✅ CellView 리팩터링
struct CellView: View {
    let day: Int
    let state: CellState

    var body: some View {
        VStack(spacing: 4) {
            Text("\(day)")
                .frame(width: 45, height: 45)
                .background(
                    Circle()
                        .fill(state.color)
                        .overlay(Circle().stroke(state.borderColor, lineWidth: 2))
                )
                .font(.title3)
                .foregroundColor(state.textColor)
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
            ),
            Event(
                eventId: 3,
                clubId: 1,
                startTime: tomorrow,
                endTime: Calendar.current.date(byAdding: .hour, value: 3, to: tomorrow)!,
                description: "프리뷰 이벤트 - 내일2"
            )
//            Event(Color("#8ce366").opacity(0.9)
//                eventId: 4,
//                clubId: 1,
//                startTime: tomorrow,
//                endTime: Calendar.current.date(byAdding: .hour, value: 3, to: tomorrow)!,
//                description: "프리뷰 이벤트 - 내일2"
//            )
        ]
        print(vm.events)
        return vm
    }
}
