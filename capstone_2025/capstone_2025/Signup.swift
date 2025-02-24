import SwiftUI

struct SignUp: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // 로고 텍스트
            Text("CLUB HOUSE")
                .font(.custom("Comfortaa-Bold", size: 30)) // 원하는 폰트 설정 필요
                .padding(.top, 50)

            // 입력 필드
            Group {
                CustomTextField(title: "이름", text: $name)
                CustomTextField(title: "아이디", text: $username)
                CustomSecureField(title: "비밀번호", text: $password)
                CustomTextField(title: "전화번호", text: $phoneNumber)
            }
            .padding(.horizontal, 40)

            // 가입하기 버튼
            Button(action: {
                print("가입하기 버튼 클릭됨")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 205, height: 55)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)

                    Text("가입하기")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 20)
        }
        .padding()
    }
}

// 일반 입력 필드 (이름, 아이디, 전화번호)
struct CustomTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            TextField("", text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .font(.system(size: 18, weight: .bold))
        }
    }
}

// 비밀번호 입력 필드
struct CustomSecureField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }

            SecureField("", text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .font(.system(size: 18, weight: .bold))
        }
    }
}

#Preview {
    SignUp()
}

