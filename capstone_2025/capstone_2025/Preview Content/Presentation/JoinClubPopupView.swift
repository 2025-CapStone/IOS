import SwiftUI

/// 클럽 ID를 입력해 가입을 시도하는 팝업
struct JoinClubPopupView: View {
    @Binding var isVisible: Bool          // 외부에서 on/off 제어
    var onJoin: (String) -> Void          // "가입" 버튼 액션

    @State private var clubIdText = ""    // 입력받을 클럽 ID

    var body: some View {
        ZStack {
            // 반투명 배경
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isVisible = false }

            // 팝업 본문
            VStack(spacing: 16) {
                Image("popupHeader")              // 헤더 이미지
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()

                Text("가입할 클럽의 ID를 입력하세요")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                TextField("클럽 ID", text: $clubIdText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding(.horizontal, 24)

                HStack(spacing: 40) {
                    Button("가입")  { onJoin(clubIdText) }   // “가입”
                    Button("닫기")  { isVisible = false  }   // “닫기”
                }
                .font(.system(size: 14, weight: .semibold))
                .padding(.bottom, 12)
            }
            .frame(width: 260)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
        }
    }
}
