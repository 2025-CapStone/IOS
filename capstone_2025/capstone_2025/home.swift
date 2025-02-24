import SwiftUI

struct home: View {
    let clubs = [
        ("burger1", "동호회 이름"),
        ("burger2", "동호회 이름1"),
        ("burger3", "동호회 이름2"),
        ("burger4", "동호회 이름3")
    ]
    
    var body: some View {
        NavigationView { // ✅ 네비게이션 뷰 추가
            VStack(spacing: 20) {
                // 상단 네비게이션 바
                HStack {
                    Image("logo") // 좌측 상단 로고
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Spacer()

                    Button(action: {
                        print("추가 버튼 클릭됨")
                    }) {
                        Image(systemName: "plus") // 우측 상단 추가 버튼
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50) // SafeArea와 겹치지 않도록 조정

                // CLUB HOUSE 텍스트
                Text("CLUB HOUSE")
                    .font(.custom("Comfortaa-Bold", size: 24)) // 원하는 폰트 적용
                    .padding(.top, -10)

                // 검색창 및 필터 버튼을 포함한 HStack
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
                        .frame(height: 40)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        .shadow(radius: 2)
                    }
                    Spacer(minLength: 15)
                    
                    // ✅ 필터 버튼 → home_filter로 이동하는 NavigationLink 추가
//                    NavigationLink(destination: home_filter()) {
//                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.black)
//                            .background(Color.white)
//                            .clipShape(Circle())
//                            .shadow(radius: 2)
//                    }
                }
                .padding(.horizontal, 20)

                // 동호회 목록 (그리드 형식)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(clubs, id: \.0) { club in
                        VStack {
                            Image(club.0) // 이미지 파일명
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            Text(club.1)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .frame(width: 150, height: 160)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white) // 배경 흰색으로 설정
            .edgesIgnoringSafeArea(.top) // SafeArea 고려하여 상단 배경 적용
        }
    }
}

#Preview {
    home()
}
