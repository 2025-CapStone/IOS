
import SwiftUI

struct introduce_2: View {
    @State private var currentPage = 1 // 현재 페이지 (2/3)
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        VStack {
            // 상단 네비게이션 (2/3 단계 & Skip 버튼)
            HStack {
                Text("2 / 3")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))

                Spacer()

                Button(action: {
                    print("introduce2 Skip 버튼 클릭됨") // 스킵 기능 추가 가능
                    router.path.append(AppRoute.login)
                }) {
                    Text("Skip")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()

            // 일정 관리 아이콘
            Image("schedule") // Assets에 이미지 추가 필요
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            // 타이틀
            Text("일정 관리")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 10)
                .padding(.bottom, 20)

            // 설명 텍스트
            VStack(spacing: 10) {
                Text("동호회 캘린더를 통해\n한달 단위로 동호회 일정을 확인 가능해요.")
                
            }
            .font(.system(size: 15))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)

            // 추가 설명 텍스트
            Text("동호회 일정 알림은\n당일 참가 인원들에게 전송됩니다.")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 5)

            Spacer()

            // 페이지 인디케이터 & Prev / Next 버튼
            HStack {
                // Prev 버튼
                Button(action: {
                    print("Prev 버튼 클릭됨") // 이전 화면으로 이동 가능
                    router.path.removeLast()
                }) {
                    Text("Prev")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray) // 흐린 회색
                }

                Spacer()

                // 페이지 인디케이터 (Dots)
                HStack(spacing: 8) {
                    Circle().fill(Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                    Circle().fill(Color.black)
                        .frame(width: 8, height: 8)
                    Circle().fill(Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }

                Spacer()

                // Next 버튼
                Button(action: {
                    print("Next 버튼 클릭됨") // 다음 화면으로 이동 가능
                    router.path.append(AppRoute.introduce3)

                }) {
                    Text("Next")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    introduce_2()
}
