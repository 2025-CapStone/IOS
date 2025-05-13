import SwiftUI

/// “XX 동호회에 가입하시겠습니까?” 중간 확인 팝업
struct JoinConfirmPopupView: View {
    
    var clubId: String             // 사용자가 입력한 ID (표시용)
    var clubName: String           // 조회된 클럽 이름
    @Binding var isVisible: Bool
    var onConfirm: () -> Void      // “확인” → 실제 가입 실행
    

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isVisible = false }

            VStack(spacing: 16) {
                Text("‘\(clubName)’\n(ID \(clubId))\n클럽에 가입하시겠습니까?")
                    .font(.system(size: 15, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                HStack(spacing: 40) {
                    Button("취소")  { isVisible = false }
                    Button("확인") {
                        isVisible = false      // 확인 팝업 닫기
                        onConfirm()            // 최종 가입
                    }
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
