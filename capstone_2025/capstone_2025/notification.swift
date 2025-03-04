import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss  // ✅ 뒤로가기 기능 추가
    @State private var title: String = ""
    @State private var selectedGrade: String = "수신 등급"
    @State private var message: String = ""

    var body: some View {
        VStack(spacing: 20) { // 🔹 전체적인 간격 조정
            
            // 🔹 네비게이션 바
            HStack {
                Image("logo") // 좌측 상단 로고
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Spacer()

                // ✅ 뒤로가기 버튼을 눌렀을 때 이전 화면으로 이동
                Button(action: {
                    dismiss() // 현재 화면을 닫고 이전 화면으로 이동
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // 🔹 알림 제목
            Text("발신자 님이 알림을 보냈어요!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            // 🔹 제목 입력 필드
            TextField("제목", text: $title)
                .padding()
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 20)

            
            // 🔹 등급 선택 버튼
            Button(action: {
                print("등급 선택 버튼 클릭됨")
            }) {
                HStack {
                    Image(systemName: "flag.fill") // 깃발 아이콘
                        .foregroundColor(.black)

                    Text(selectedGrade) // 현재 선택된 등급
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.down") // 드롭다운 아이콘
                        .foregroundColor(.black)
                }
                .padding()
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 20)
            }

            // 🔹 내용 입력 필드
            TextEditor(text: $message)
                .frame(height: 150)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

// ✅ 미리보기
#Preview {
    NavigationStack {
        NotificationView()
    }
}
