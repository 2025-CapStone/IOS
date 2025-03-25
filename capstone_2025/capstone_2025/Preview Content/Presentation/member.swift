import SwiftUI

struct member: View {
    @State private var isMenuOpen = false // ✅ 메뉴 상태
    @EnvironmentObject var router: NavigationRouter // ✅ 네비게이션 라우터 추가
   
    var body: some View {
        ZStack {
            VStack(spacing: 50) { // 🔹 전체적인 간격 조정
                
                // 🔹 네비게이션 바
                HStack {
                    Image("logo") // 좌측 상단 로고
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    Spacer()

                    // ✅ 뒤로가기 버튼을 눌렀을 때 budget 화면으로 이동
                    Button(action: {
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)

                // 🔹 차트 제목 + 차트 뷰 그룹화
                HStack(spacing: 40) { // 🔹 차트 간격 조정
                    VStack(spacing: 10) {
                        Text("월간 회원 수")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                        ChartView()
                    }
                    .frame(maxWidth: .infinity) // 🔹 중앙 정렬
                    
                    VStack(spacing: 10) {
                        Text("등급??")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                        ChartView()
                    }
                    .frame(maxWidth: .infinity) // 🔹 중앙 정렬
                }
                .padding(.horizontal, 25)
                
                Spacer(minLength: 30) // 🔹 버튼과 차트 간 간격 추가

                // 🔹 버튼 섹션 (더 아래로 배치)
                VStack(spacing: 15) {
                    CustomButton(title: "알림")
                    CustomButton(title: "관리")
                    CustomButton(title: "보고서")
                }
                .padding(.bottom, 80) // 🔹 화면 중앙부에 위치하도록 조정
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            
            // ✅ 메뉴바 추가 (club_intro와 동일한 형식)
            if isMenuOpen {
                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            MenuItem(title: "일정관리")
                            MenuItem(title: "회원관리")
                            MenuItem(title: "예산관리")
                            Divider()
                            // ✅ 로그아웃 버튼 수정
                            MenuItem(title: "로그아웃", isLogout: true, action: {
                                withAnimation {
                                    router.path = NavigationPath() // ✅ 네비게이션 스택 초기화
                                    router.path.append(AppRoute.login) // ✅ Login 화면으로 이동
                                }
                            })
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

// ✅ 차트 뷰
struct ChartView: View {
    var body: some View {
        VStack {
            // 막대 그래프
            HStack(alignment: .bottom, spacing: 12) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 20, height: 50)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 20, height: 80)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.8))
                    .frame(width: 20, height: 120)
            }
            .frame(height: 140)
            
            // 요일 라벨
            HStack(spacing: 12) {
                Text("Sun").font(.system(size: 12)).foregroundColor(.gray)
                Text("Mon").font(.system(size: 12)).foregroundColor(.gray)
                Text("Tue").font(.system(size: 12, weight: .bold)).foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// ✅ 버튼 뷰
struct CustomButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.gray)
            .frame(width: 269, height: 59)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
}

// ✅ 메뉴 아이템 뷰 (club_intro와 동일한 기능)
struct Menu: View {
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
    member()
}
