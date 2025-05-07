

import SwiftUI

struct SignUp: View {
    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: SignupViewModel
    @State private var showAlert: Bool = false

    let regions = [
        "서울특별시 강남구",
        "서울특별시 성북구",
        "경기도 성남시",
        "부산광역시 해운대구",
        "대전광역시 서구"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("CLUB HOUSE")
                    .font(.custom("Comfortaa-Bold", size: 30))
                    .padding(.top, 50)

                Group {
                    CustomTextField(title: "이름", text: $viewModel.name)
                    CustomTextField(title: "비밀번호", text: $viewModel.password)
                    CustomTextField(title: "전화번호", text: $viewModel.phoneNumber)

                    Picker("지역", selection: $viewModel.region) {
                        ForEach(regions, id: \.self) { region in
                            Text(region).tag(region)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Picker("성별", selection: $viewModel.gender) {
                        Text("남자").tag(SignupUser.Gender.male)
                        Text("여자").tag(SignupUser.Gender.female)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    DatePicker("생년월일", selection: $viewModel.birthDate, displayedComponents: .date)
                    CustomTextField(title: "구력 (연 단위 숫자)", text: $viewModel.career)
                }
                .padding(.horizontal, 40)

                Button(action: {
                    viewModel.signup()
                    showAlert = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 205, height: 55)
                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)

                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("가입하기")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.top, 20)
                .disabled(viewModel.isLoading)
                .alert(isPresented: $showAlert) {
                    if viewModel.isSuccess {
                        return Alert(
                            title: Text("성공"),
                            message: Text("회원가입에 성공했습니다."),
                            dismissButton: .default(Text("확인")) {
                                router.path = NavigationPath()
                                router.path.append(AppRoute.login)
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("오류"),
                            message: Text(viewModel.errorMessage ?? "알 수 없는 에러"),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                }
            }
            .padding()
        }
    }
}

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
