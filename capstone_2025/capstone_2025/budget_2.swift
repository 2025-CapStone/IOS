import SwiftUI

struct budget_2: View {
    @State private var selectedYear: String = "2017 년"
    @State private var selectedMonth: String = "3 월"
    @State private var isMenuOpen = false // ✅ 메뉴 상태 추가
    @EnvironmentObject var router: NavigationRouter // ✅ 네비게이션 라우터 추가

    var body: some View {
        ZStack {
            VStack(spacing: 20) { // 전체적인 간격 조정
                
                // 🔹 상단 네비게이션 바
                HStack {
                    Image("logo") // 좌측 상단 로고
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    Spacer()

                    // ✅ 메뉴 버튼 추가
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 5)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // 🔹 연도 & 월 선택 버튼
                HStack {
                    Button(action: { print("연도 선택") }) {
                        HStack {
                            Text(selectedYear)
                                .foregroundColor(.black) // ✅ 텍스트 색상 검정으로 변경
                            Image(systemName: "chevron.down") // 드롭다운 아이콘
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 148, height: 49)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }

                    Spacer()

                    Button(action: { print("월 선택") }) {
                        HStack {
                            Text(selectedMonth)
                                .foregroundColor(.black) // ✅ 텍스트 색상 검정으로 변경
                            Image(systemName: "chevron.down") // 드롭다운 아이콘
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 83, height: 49)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)

                // 🔹 이번달 요약 텍스트
                Text("이번달은...")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 10)

                // 🔹 차트 뷰
                HStack(spacing: 50) {
                    VStack {
                        Text("지출")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 51, height: 119)

                        Text("23,000,000")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }

                    VStack {
                        Text("수입")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 51, height: 79)

                        Text("17,000,000")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)

                // 🔹 요약 설명
                VStack {
                    Text("저번달에 비해 2,000,000원을 더 사용하였고")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)

                    Text("저번달에 비해 200,000원을 더 아꼈습니다!")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 10)

                Spacer()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            
            // ✅ 메뉴바 추가
            if isMenuOpen {
                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            MenuItem(title: "일정 관리")
                            MenuItem(title: "회원 관리")
                            MenuItem(title: "예산 관리")
                            Divider()
                            // ✅ 로그아웃 버튼 추가
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

// ✅ 메뉴 아이템 뷰 (budget과 동일한 기능)
struct MenuItems: View {
    var title: String
    var isLogout: Bool = false
    var action: (() -> Void)? // ✅ 로그아웃 동작 추가
    
    var body: some View {
        Button(action: {
            action?()
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

// ✅ 미리보기
#Preview {

    NavigationStack {
            budget_2()
                .environmentObject(NavigationRouter()) // ✅ 환경 객체 추가
        }
}
