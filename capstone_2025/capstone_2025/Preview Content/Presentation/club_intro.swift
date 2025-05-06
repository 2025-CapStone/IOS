import SwiftUI

struct club_intro: View {
    @State private var club: Club
    let onUpdate: (Club) -> Void

    @State private var isMenuOpen = false
    @EnvironmentObject var router: NavigationRouter

    init(club: Club, onUpdate: @escaping (Club) -> Void) {
        _club = State(initialValue: club)
        self.onUpdate = onUpdate
    }

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                HStack {
                    Image("ball")
                        .resizable().scaledToFit().frame(width: 32, height: 32)
                    Spacer()
                    Button { isMenuOpen.toggle() } label: {
                        Image(systemName: "ellipsis")
                            .resizable().scaledToFit().frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 20)

                clubLogo
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                HStack(spacing: 6) {
                    Text(club.name)
                        .font(.system(size: 18, weight: .bold))

                    NavigationLink {
//                        club_edit(
//                            club: club,
//                            onSave: { edited in
//                                club = edited
//                                onUpdate(edited)
//                            }
//                        )
                    } label: {
                        Text("Edit profile")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1))
                    }
                }

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

                Text(club.description)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())

            if isMenuOpen { menuPopup }
        }
    }

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

    private var menuPopup: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    MenuItem(title: "일정관리", clubId: club.id)
                    MenuItem(title: "회원관리")
                    MenuItem(title: "예산관리")
                    Divider()
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



//// ✅ 메뉴 아이템 뷰
struct MenuItem: View {
    var title: String
    var isLogout: Bool = false
    var clubId: Int? = nil // ✅ 추가
    var action: (() -> Void)?
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Button(action: {
            action?()
            print("\(title) 클릭됨")

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
                    .foregroundColor(isLogout ? .red : .black)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
    }
}
