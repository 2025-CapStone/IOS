import SwiftUI

// MARK: - 모델 ----------------------------------------------------------------
struct Schedule: Identifiable {
    let id = UUID()
    let eventId: Int
    let startTime: String
    let endTime: String
    let title: String
}

// MARK: - MainCalendarView ----------------------------------------------------
struct MainCalendarView: View {
    var clubId: Int?
    @ObservedObject var viewModel: EventListViewModel
    
    @State private var showCreateTaskView  = false
    @State private var showScheduleListView = false
    @State private var showPopup           = false
    @State private var selectedDate        = Date()
    
    var body: some View {
        ZStack {
            CalendarView(selectedDate: $selectedDate,
                         showPopup:    $showPopup)
                .blur(radius: showCreateTaskView || showScheduleListView ? 5 : 0)
                .disabled(showCreateTaskView || showScheduleListView)
            
            if showPopup {
                Color.black.opacity(0.3).ignoresSafeArea()
                    .onTapGesture { showPopup = false }
                EventPopupView(showPopup:            $showPopup,
                               showCreateTaskView:   $showCreateTaskView,
                               showScheduleListView: $showScheduleListView)
                    .transition(.scale)
            }
            
            if showCreateTaskView {
                CreateTaskView(showCreateTaskView: $showCreateTaskView,
                               selectedDate: selectedDate)
                    .environmentObject(viewModel)
            } else if showScheduleListView {
                ScheduleListView(showScheduleListView: $showScheduleListView,
                                 selectedDate: selectedDate,
                                 events: viewModel.events)
            }
        }
        .onAppear {
            if let cid = ClubEventContext.shared.selectedClubId {
                viewModel.setClubId(cid)
                viewModel.fetchEvents(for: cid)
            }
        }
    }
}

// MARK: - CalendarView (달력 + 사이드 메뉴 + 접근 제한 팝업) --------------------
struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var showPopup: Bool
    
    @State private var month = Date()
    @EnvironmentObject private var router: NavigationRouter
    
    // 메뉴·팝업 상태
    @State private var isMenuOpen      = false
    @State private var showDeniedPopup = false
    @State private var deniedMessage   = ""
    
    var body: some View {
        ZStack {
            // ── 달력 본문 ───────────────────────────────────
            VStack {
                header
                Spacer(minLength: 10)
                monthHeader
                calendarGrid
                Spacer()
            }
            
            // ── 사이드 메뉴 ───────────────────────────────
            if isMenuOpen {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { withAnimation { isMenuOpen = false } }
                
                VStack(alignment: .leading, spacing: 10) {
                    menuItem("일정관리") {
                        router.path.append(AppRoute.calendar)
                    }
                    menuItem("회원관리", restricted: true)
                    menuItem("예산관리", restricted: true)
                    Divider()
                    menuItem("로그아웃", isLogout: true) {
                        router.path.append(AppRoute.login)
                    }
                }
                .frame(width: 150)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 50)
                .padding(.trailing, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: .topTrailing)
            }
            
            // ── 접근 제한 팝업 ─────────────────────────────
            if showDeniedPopup {
                AccessDeniedPopup(message: deniedMessage) {
                    showDeniedPopup = false
                }
            }
        }
    }
    
    // MARK: 메뉴 항목 뷰
    @ViewBuilder
    private func menuItem(_ title: String,
                          isLogout: Bool = false,
                          restricted: Bool = false,
                          action: (() -> Void)? = nil) -> some View {
        Button {
            isMenuOpen = false
            if restricted {
                deniedMessage   = "동호회 운영진 등급의 회원만 접속 가능합니다."
                showDeniedPopup = true
            } else {
                action?()
            }
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isLogout ? .red : .black)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .tint(.black)
    }
    
    // MARK: 헤더
    private var header: some View {
        HStack {
            Image("ball").resizable().scaledToFit()
                .frame(width: 32, height: 32)
                .onTapGesture { router.path.append(AppRoute.home) }
            Spacer()
            Button { withAnimation { isMenuOpen.toggle() } } label: {
                Image(systemName: "ellipsis")
                    .resizable().scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            .tint(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: 월 표시
    private var monthHeader: some View {
        VStack {
            Text(dateString(selectedDate, "yyyy년 MM월"))
                .font(.title2).bold().padding(.bottom, 10)
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
    
    // MARK: 날짜 그리드
    private var calendarGrid: some View {
        let total = Calendar.current.range(of: .day, in: .month, for: month)!.count
        let first = firstWeekday(of: month) - 1
        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
            ForEach(0..<42) { idx in
                if idx < first || idx >= first + total {
                    Color.clear.frame(width: 40, height: 40)
                } else {
                    let day = idx - first + 1
                    if let date = Calendar.current.date(byAdding: .day, value: day - 1,
                                                        to: startOfMonth(month)) {
                        let sel = Calendar.current.isDate(selectedDate, inSameDayAs: date)
                        CellView(day: day, isSelected: sel)
                            .onTapGesture {
                                selectedDate = date
                                showPopup    = true
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
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
struct CellView: View {
    let day: Int; let isSelected: Bool
    var body: some View {
        Text("\(day)")
            .frame(width: 45, height: 45)
            .background(
                Circle().fill(isSelected ? Color.black : Color.gray.opacity(0.2))
                    .overlay(Circle().stroke(isSelected ? .black : .clear,
                                             lineWidth: 2))
            )
            .font(.title3)
            .foregroundColor(isSelected ? .white : .black)
    }
}




// MARK: - EventPopupView -------------------------------------------------------
struct EventPopupView: View {
    @Binding var showPopup: Bool
    @Binding var showCreateTaskView: Bool
    @Binding var showScheduleListView: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 10)
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button { showPopup = false } label: {
                        Image(systemName: "arrow.left")
                            .resizable().scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        showPopup = false; showScheduleListView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCreateTaskView = true }
                    } label: {
                        Text("일정 생성")
                            .frame(width: 120, height: 40)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.gray.opacity(0.5)))
                    }
                    Button {
                        showPopup = false; showCreateTaskView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showScheduleListView = true }
                    } label: {
                        Text("일정 확인 / 출첵")
                            .frame(width: 120, height: 40)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.gray.opacity(0.5)))
                    }
                }
                .foregroundColor(.black)
                .padding(.bottom, 16)
            }
            .padding(.top, 16)
            .frame(width: 300, height: 150)
        }
        .frame(width: 300, height: 150)
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

#Preview {
    MainCalendarView(clubId: 1, viewModel: .dummy())
        .environmentObject(NavigationRouter())
}
