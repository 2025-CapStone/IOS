import SwiftUI

// 필터는 안하고 edit profie 동호회 관리에서만 운영진 특ㅎ화 두기
// 아무것도 가입 안한 사람은 클럽 아무거나 보여주기
// 클럽 회장은 뭔가 왕관 아이콘?

struct home: View {
    let clubs = [
        ("burger1", "동호회 이름"),
        ("burger2", "동호회 이름1"),
        ("burger3", "동호회 이름2"),
        ("burger4", "동호회 이름3")
    ]
    
    @State private var isFilterPopupVisible = false
    @State private var userRole: String = ""
    @State private var isLogoutAlertVisible = false // 로그아웃 알림창 표시 여부
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 20) {
                    Spacer(minLength: 50) // ✅ 상단 여백 추가하여 전체적으로 내림
                    
                    // ✅ 상단 네비게이션 바
                    HStack {
                        Image("logo") // 좌측 상단 로고
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40).onTapGesture {
                                isLogoutAlertVisible = true // 로고 터치 시 알림창 표시
                            }
                
                      

                        Spacer()

                        // ✅ + 버튼을 클릭하면 club_create 화면으로 이동
                        NavigationLink(destination: club_create()) {
                            
                            Image(systemName: "plus") // 우측 상단 추가 버튼
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)

                    // ✅ CLUB HOUSE 텍스트
                    Text("CLUB HOUSE")
                        .font(.custom("Comfortaa-Bold", size: 24))
                        .padding(.top, 10) // ✅ 약간 아래로 내림

                    // ✅ 검색창 및 필터 버튼
                    HStack {
                        Button(action: {
                            print("검색 버튼 클릭됨")
                        }) {
                            HStack {
                                Text("검색") // 검색 텍스트
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.leading, 15)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity) // ✅ 검색창 너비 확장
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                            .shadow(radius: 2)
                        }
                        
                        // ✅ 필터 버튼 (검색창 옆으로 이동)
                        Button(action: {
                            withAnimation {
                                isFilterPopupVisible = true
                            }
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10) // ✅ 검색창 위치 조정

                    // ✅ 동호회 목록 (그리드 형식)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(clubs, id: \.0) { club in
                            NavigationLink(destination: club_intro()) { // ✅ 동호회 클릭 시 club_intro 이동
                                VStack {
                                    Image(club.0)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120) // ✅ 이미지 크기 증가
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    
                                    Text(club.1)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                }
                                .frame(width: 170, height: 180) // ✅ 크기 조정
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity) // ✅ 가로 너비 확장

                    Spacer() // ✅ 화면 아래 여백 추가
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // ✅ 전체 화면 조정
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            } // 로그아웃 알림창 표시
            if isLogoutAlertVisible {
                CustomAlertView(
                    title: "로그아웃",
                    message: "로그아웃 하시겠습니까?",
                    onConfirm: {
                        // 로그아웃 처리 로직
                        print("로그아웃 확인")
                        isLogoutAlertVisible = false
                        router.path=NavigationPath()
                    },
                    onCancel: {
                        isLogoutAlertVisible = false
                    }
                )
                .zIndex(1) // 알림창을 상위에 표시
            }

            // ✅ 필터 팝업 (필터 버튼 클릭 시만 나타남)
            if isFilterPopupVisible {
                FilterPopupView(isVisible: $isFilterPopupVisible, userRole: $userRole)
            }
        }
    }
}

#Preview{
    home().environmentObject(CustomAlertManager())
}
