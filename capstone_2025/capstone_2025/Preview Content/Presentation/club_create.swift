import SwiftUI

struct club_create: View {
    @State private var clubName: String = ""
    @State private var location: String = ""
    @State private var maxMembers: String = ""
    @State private var clubDescription: String = ""

    var body: some View {
        VStack(spacing: 25) {
            Spacer(minLength: 150) // ✅ 화면 전체적으로 아래로 내림
            
            // ✅ 상단 이미지 (사진 업로드 아이콘)
            Image("camera")
                .resizable()
                .scaledToFit()
                .frame(width: 115, height: 85)
                .clipShape(Circle())
                .shadow(radius: 5)

            // ✅ 입력 필드
            VStack(spacing: 20) {
                CustomInputField(title: "동호회 이름", text: $clubName)
                CustomInputField(title: "지역", text: $location)
                CustomInputField(title: "최대 인원수", text: $maxMembers)
                CustomInputField(title: "동호회 설명", text: $clubDescription)
            }
            .padding(.horizontal, 20)

            // ✅ 동호회 명부 업로드 버튼
            Button(action: {
                print("동호회 명부 업로드 클릭됨")
            }) {
                Text("동호회 명부 업로드")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 296, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.top, 10)

            // ✅ 가입하기 버튼
            Button(action: {
                print("가입하기 버튼 클릭됨")
            }) {
                Text("가입하기")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 205, height: 55)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
            }
            .padding(.top, 20)

            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// ✅ 커스텀 입력 필드
struct CustomInputFieldView: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .shadow(radius: 1)
        }
    }
}

// ✅ 미리보기
#Preview {
    club_create()
}
