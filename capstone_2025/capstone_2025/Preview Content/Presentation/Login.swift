
import SwiftUI

struct Login: View {
    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image("logo 1")                 // ← Asset 이름이 “logo 1”일 때
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)   // 크기 조정은 자유
                        .clipShape(Circle())              // 원형 자를 필요 없으면 삭제
                        .shadow(radius: 5)

            // 로고 텍스트
            Text("OnClub")
                .font(.custom("Comfortaa-Bold", size: 30))
                .padding(.top, 50)

            // 전화번호 입력 필드
            VStack(alignment: .leading) {
                Text("전화번호")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack {
                    Image("id")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 10)

                    TextField("ex ) xxx - xxxx - xxxx", text: $viewModel.phoneNumber)
                        .padding(10)
                        .keyboardType(.phonePad)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal, 40)

            // 비밀번호 입력 필드
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(.headline)
                    .foregroundColor(.black)

                HStack {
                    Image("password")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 10)

                    SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                        .padding(10)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal, 40)

            // 로그인 버튼
            Button(action: {
                viewModel.login()
            }) {
                Text("로그인")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)

            // 회원가입 버튼
            Button(action: {
                router.path.append(AppRoute.signup)
            }) {
                Text("회원가입")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.top, 10)
        }
        .padding()
        .onReceive(viewModel.$isSuccess) { success in
            if success {
                router.path = NavigationPath()
                AppState.shared.notificationViewModel.fetchAll()
                router.path.append(AppRoute.home)
            }
        }
        .alert("로그인 실패", isPresented: $viewModel.showErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        }
    }
}

#Preview {
    Login(viewModel: AppDIContainer.shared.makeLoginViewModel())
        .environmentObject(NavigationRouter())
}
