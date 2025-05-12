import SwiftUI

// MARK: - 클럽 소개 ------------------------------------------------------------
struct club_intro: View {
    @State private var club: Club
    let onUpdate: (Club) -> Void

    @State private var isMenuOpen        = false
    @State private var showAccessDenied  = false        // ⭐️
    @State private var deniedMessage     = ""           // ⭐️
    
    @EnvironmentObject var router: NavigationRouter

    init(club: Club, onUpdate: @escaping (Club) -> Void) {
        _club = State(initialValue: club)
        self.onUpdate = onUpdate
    }

    var body: some View {
        ZStack {
            // ---------- 본문 ----------
            VStack(spacing: 30) {
                // 네비게이션 바
                HStack {
                    Image("ball")
                        .resizable().scaledToFit().frame(width: 32, height: 32)
                    Spacer()
                    Button { isMenuOpen.toggle() } label: {
                        Image(systemName: "ellipsis")
                            .resizable().scaledToFit().frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 20)

                // 클럽 로고
                clubLogo
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                // 클럽 이름 + 프로필 수정
                HStack(spacing: 6) {
                    Text(club.name)
                        .font(.system(size: 18, weight: .bold))

                
                }

                // 통계 영역
                HStack {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("14")
                    }.frame(maxWidth: .infinity, alignment: .leading)

                    VStack {
                        Text("SINCE").font(.footnote).foregroundColor(.gray)
                        Text(club.createdAt.formatted(date: .numeric, time: .omitted))
                    }.frame(maxWidth: .infinity)

                    VStack {
                        Image(systemName: "mappin")
                        Text("강서구")
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 40)

                // 설명
                Text(club.description)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())

            // ---------- 사이드 메뉴 ----------
            if isMenuOpen { menuPopup }

            // ---------- 접근 제한 팝업 ----------
            if showAccessDenied {                    // ⭐️
                AccessDeniedPopup(message: deniedMessage) {
                    showAccessDenied = false
                }
            }
        }
    }

    // MARK: - 로고
    private var clubLogo: some View {
        Group {
            if let url = club.logoURL.flatMap(URL.init) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let img): img.resizable().scaledToFill()
                    default: Image("defaultLogo").resizable().scaledToFill()
                    }
                }
            } else {
                Image("defaultLogo").resizable().scaledToFill()
            }
        }
    }

    // MARK: - 메뉴 팝업
    private var menuPopup: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    // 일정관리 (정상 진입)
                    MenuItem(title: "일정관리", clubId: club.id)

                    // 회원관리 (제한)
                    MenuItem(
                        title: "회원관리",
                        restricted: true,                     // ⭐️
                        action: {                             // ⭐️
                            isMenuOpen = false
                            deniedMessage = "동호회 운영진 등급의 회원만 접속 가능합니다."
                            showAccessDenied = true
                        }
                    )

                    // 예산관리 (제한)
                    MenuItem(
                        title: "예산관리",
                        restricted: true,                     // ⭐️
                        action: {
                            isMenuOpen = false
                            deniedMessage = "동호회 운영진 등급의 회원만 접속 가능합니다."
                            showAccessDenied = true
                        }
                    )

                    Divider()

                    // 로그아웃
                    MenuItem(title: "로그아웃", isLogout: true)
                }
                .frame(width: 150)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 50).padding(.trailing, 10)
            }
            Spacer()
        }
        .background(Color.black.opacity(0.5).ignoresSafeArea())
        .onTapGesture { isMenuOpen = false }
    }
}

// MARK: - 미리보기 --------------------------------------------------------------
#Preview {
    let dto = ClubResponseDTO(
        clubId: 99,
        clubName: "프리뷰 테스트 클럽",
        clubDescription: "프리뷰용 설명입니다.",
        clubLogoURL: nil,
        clubBackgroundURL: nil,
        clubCreatedAt: "2025-03-08T18:20:56Z"
    )
    let club = Club(from: dto)
    return club_intro(club: club) { _ in }
        .environmentObject(NavigationRouter())
}

// MARK: - 메뉴 항목 -------------------------------------------------------------
struct MenuItem: View {
    var title: String
    var isLogout: Bool = false
    var clubId: Int? = nil
    var restricted: Bool = false
    var action: (() -> Void)? = nil

    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Button(action: {
            action?()
            guard !restricted else { return }

            if title.hasPrefix("일정"), let id = clubId {
                ClubEventContext.shared.selectedClubId = id
                router.path.append(AppRoute.calendar)
            } else if title.hasPrefix("예산") {
                router.path.append(AppRoute.budget)
            } else if title.hasPrefix("회원") {
                router.path.append(AppRoute.member)
            } else if title.hasSuffix("아웃") {
                router.path.append(AppRoute.login)
            }
        }) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isLogout ? .red : .black)   // ← 텍스트 색
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)       // 🔹 기본 파란 하이라이트 제거
        .tint(.black)              // 🔹 버튼 강조 색을 검은색으로 고정
    }
}

// MARK: - 접근 제한 팝업 --------------------------------------------------------
struct AccessDeniedPopup: View {
    var message: String
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)

            Button("닫기") {                 // 버튼 액션
                onClose()
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.horizontal, 40)
            .padding(.vertical, 8)
            .background(Color.black)        // 🔹 여기! 파란색 → 검은색
            .foregroundColor(.white)        // 글자색은 흰색 유지
            .cornerRadius(8)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(maxWidth: 280)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 센터 정렬
        .background(Color.black.opacity(0.5).ignoresSafeArea())
    }
}
