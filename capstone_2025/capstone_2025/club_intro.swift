import SwiftUI

struct club_intro: View {
    @State private var isMenuOpen = false // ✅ 메뉴 상태 추가
    
    // ✅ 사용자 데이터 (서버/API 연동 가능)
    @State private var clubName: String = "동호회 이름"
    @State private var memberCount: String = "14"
    @State private var creationDate: String = "2017.03.18"
    @State private var location: String = "강서구"
    @State private var clubDescription: String = "동호회 소개 텍스트"

    var body: some View {
        ZStack {
            VStack(spacing: 30) { // 🔹 전체적으로 간격 증가
                
                // 🔹 상단 네비게이션 바
                HStack {
                    Image("logo") // 좌측 상단 로고
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    Spacer()
                    
                    // ✅ 메뉴 버튼
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 🔹 동호회 이미지
                Image("pngwing")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 20)

                // 🔹 동호회 이름 & Edit Profile 버튼
                HStack {
                    Text(clubName)
                        .font(.system(size: 18, weight: .bold))
                    
                    NavigationLink(destination: club_edit()) { // ✅ Edit Profile 클릭 시 이동
                        Text("Edit profile")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)

                // 🔹 동호회 정보
                HStack {
                    VStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        Text(memberCount)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Text("SINCE")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(creationDate)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack {
                        Image(systemName: "mappin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        Text(location)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 40)

                // 🔹 동호회 소개 텍스트
                Text(clubDescription)
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top, 20)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            
            // ✅ 메뉴바 수정 (우측 상단에서 나옴)
            if isMenuOpen {
                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            MenuItem(title: "일정관리")
                            MenuItem(title: "회원관리")
                            MenuItem(title: "예산관리")
                            Divider()
                            MenuItem(title: "로그아웃", isLogout: true)
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
    }
}

// ✅ 메뉴 아이템 뷰
struct MenuItem: View {
    var title: String
    var isLogout: Bool = false
    
    var body: some View {
        Button(action: {
            print("\(title) 클릭됨")
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

#Preview {
    club_intro()
}
