
import SwiftUI

struct onboarding: View {
    @Environment(\.presentationMode) var presentationMode // 모달 닫기 기능
    @EnvironmentObject var router: NavigationRouter


    var body: some View {
        ZStack {
            // 전체 화면 배경
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
               
                /// 스마트폰 아이콘 (원형 배경 포함)
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image("phone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .padding(.top, 8)      // 👈 위쪽으로 12-pt 내려줌


                // 앱 접근 권한 안내 제목
                Text("앱 접근 권한 안내")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.black)

                // 설명 텍스트
                Text("""
                    서비스 이용을 위해 권한 허용이 필요합니다.
                    선택적 접근권한은 해당 기능을 사용할 때 허용이 필요하며, 
                    허용하지 않아도 해당 기능 외 서비스 이용은 가능합니다.
                    """)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)

                // 선택적 접근 권한 영역 (배경 포함)
                VStack(spacing: 20) {
                    Text("선택적 접근 권한")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.top, 10)

                    VStack(alignment: .center, spacing: 12) { // 중앙 정렬
                        PermissionRow(title: "알림", description: "푸시 알림 등록 및 수신")
//                        PermissionRow(title: "위치 정보", description: "활동 위치 검색")
                        PermissionRow(title: "달력", description: "이벤트를 달력 기본 어플리케이션에 추가")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                )
            }
            .frame(width: 360)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
        }.onAppear{
            // 2초 후 자동으로 introduce_1 화면으로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                router.path.append(AppRoute.introduce)
                                }
        }
    }
}

// 개별 권한 설명 Row (title 아래에 description 배치 & 가운데 정렬)
struct PermissionRow: View {
    var title: String
    var description: String

    var body: some View {
        VStack(spacing: 5) {
            Text("| \(title) |")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.green)

            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.center) // 여러 줄일 때도 중앙 정렬
                .frame(maxWidth: .infinity)

            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .center) // 중앙 정렬
        .padding(.vertical, 5)
    }
}

#Preview {
    onboarding().environmentObject(NavigationRouter())
        .environmentObject(CustomAlertManager())
}

