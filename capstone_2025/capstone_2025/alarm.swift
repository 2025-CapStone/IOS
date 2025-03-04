import SwiftUI

struct alarm: View {
    @State private var title: String = ""
    @State private var selectedGrade: String = "수신 등급"
    @State private var message: String = ""

    @Environment(\.dismiss) var dismiss  // ✅ 화면을 닫기 위한 dismiss 추가

    let grades = ["관리자", "회원", "게스트"] // 예시 등급
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 🔹 네비게이션 바
            HStack {
                Image("logo") // 좌측 상단 로고
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Spacer()

                // ✅ 뒤로가기 버튼을 눌렀을 때 budget 화면으로 이동
                Button(action: {
                    dismiss() // 현재 화면을 닫고 이전 화면(`budget`)으로 돌아감
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // 🔹 제목 입력 필드
            TextField("제목", text: $title)
                .padding()
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 20)

            // 🔹 **등급 선택 버튼**
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

            // 🔹 푸시 알림 버튼
            Button(action: {
                print("푸시 알림 전송됨")
            }) {
                Text("푸시 알림")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 269, height: 59)
                    .background(title.isEmpty || message.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            }
            .disabled(title.isEmpty || message.isEmpty) // 제목과 내용이 비어 있으면 비활성화

            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

// ✅ 미리보기
#Preview {
    NavigationStack {
        alarm()
    }
}
