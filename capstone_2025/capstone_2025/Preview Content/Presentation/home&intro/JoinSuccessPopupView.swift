import SwiftUI

/// “~동호회에 가입되었습니다” 확인용 팝업 (JoinClubPopupView와 통일된 디자인)
struct JoinSuccessPopupView: View {
    var message: String          // 예: "테니스 동호회에 가입되었습니다."
    var onClose: () -> Void

    var body: some View {
        ZStack {
            // 반투명 딤
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            // 팝업 본문
            VStack(spacing: 16) {
                // (JoinClubPopupView 와 동일하게 헤더 이미지를 쓰고 싶다면 여기 추가)
                // Image("popupHeader")...

                // 체크 아이콘
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))

                // 메시지
                Text(message)
                    .font(.system(size: 15, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // 확인 버튼 — 파란 글씨, 배경 없음
                Button("확인") {
                    onClose()
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.blue)
                .padding(.bottom, 12)
            }
            .frame(width: 260)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
        }
    }
}
