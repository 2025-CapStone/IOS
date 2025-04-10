//import SwiftUI
//
//struct SignUp: View {
//    @State private var name: String = ""
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var phoneNumber: String = ""
//    @EnvironmentObject var router: NavigationRouter
//    @ObservedObject var viewModel: SignupViewModel
//
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // 로고 텍스트
//            Text("CLUB HOUSE")
//                .font(.custom("Comfortaa-Bold", size: 30)) // 원하는 폰트 설정 필요
//                .padding(.top, 50)
//
//            // 입력 필드
//            Group {
//                CustomTextField(title: "이름", text: $name)
//                CustomTextField(title: "아이디", text: $username)
//                CustomSecureField(title: "비밀번호", text: $password)
//                CustomTextField(title: "전화번호", text: $phoneNumber)
//            }
//            .padding(.horizontal, 40)
//
//            // 가입하기 버튼
//            Button(action: {
//                print("가입하기 버튼 클릭됨")
//                router.path.append(AppRoute.login)
//            }) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.white)
//                        .frame(width: 205, height: 55)
//                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
//
//                    Text("가입하기")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                }
//            }
//            .padding(.top, 20)
//        }
//        .padding()
//    }
//}
//
//// 일반 입력 필드 (이름, 아이디, 전화번호)
//struct CustomTextField: View {
//    var title: String
//    @Binding var text: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.black)
//
//            TextField("", text: $text)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                .font(.system(size: 18, weight: .bold))
//        }
//    }
//}
//
//// 비밀번호 입력 필드
//struct CustomSecureField: View {
//    var title: String
//    @Binding var text: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(.black)
//                Image(systemName: "lock.fill")
//                    .foregroundColor(.gray)
//            }
//
//            SecureField("", text: $text)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                .font(.system(size: 18, weight: .bold))
//        }
//    }
//}
//
//#Preview {
//    
//}
//
//#Preview {
//    SignUp(viewModel: AppDIContainer.shared.makeSignupViewModel())
//        .environmentObject(NavigationRouter())
//}
// ✅ SignUp View에서 ViewModel과 연결되어 실제 회원가입 API가 호출되도록 연결 완료

//import SwiftUI
//
//struct SignUp: View {
//    @EnvironmentObject var router: NavigationRouter
//    @ObservedObject var viewModel: SignupViewModel
//    @State private var showAlert = false
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                Text("CLUB HOUSE")
//                    .font(.custom("Comfortaa-Bold", size: 30))
//                    .padding(.top, 50)
//
//                Group {
//                    CustomTextField(title: "이름", text: $viewModel.name)
//                    CustomTextField(title: "비밀번호", text: $viewModel.password)
//                    CustomTextField(title: "전화번호", text: $viewModel.phoneNumber)
//                    CustomTextField(title: "지역 (예: 서울특별시 성북구)", text: $viewModel.region)
//                    Picker("성별", selection: $viewModel.gender) {
//                        Text("남자").tag(User.Gender.male)
//                        Text("여자").tag(User.Gender.female)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//
//                    DatePicker("생년월일", selection: $viewModel.birthDate, displayedComponents: .date)
//                    CustomTextField(title: "구력 (연 단위 숫자)", text: $viewModel.career)
//                }
//                .padding(.horizontal, 40)
//
//                Button(action: {
//                    viewModel.signup()
//                    showAlert = true
//                }) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.white)
//                            .frame(width: 205, height: 55)
//                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
//
//                        if viewModel.isLoading {
//                            ProgressView()
//                        } else {
//                            Text("가입하기")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                        }
//                    }
//                }
//                .padding(.top, 20)
//                .disabled(viewModel.isLoading)
//                .alert(isPresented: $showAlert) {
//                    if viewModel.isSuccess {
//                        return Alert(title: Text("가입 성공"), message: Text("회원가입이 완료되었습니다."), dismissButton: .default(Text("확인")))
//                    } else if let error = viewModel.errorMessage {
//                        return Alert(title: Text("가입 실패"), message: Text(error), dismissButton: .default(Text("확인")))
//                    } else {
//                        return Alert(title: Text("알림"), message: Text("알 수 없는 오류가 발생했습니다."), dismissButton: .default(Text("확인")))
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//struct CustomTextField: View {
//    var title: String
//    @Binding var text: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.black)
//
//            TextField("", text: $text)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                .font(.system(size: 18, weight: .bold))
//        }
//    }
//}

// ✅ SignUp View에서 ViewModel과 연결되어 실제 회원가입 API가 호출되도록 연결 완료 + 지역 Picker + Alert 추가

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
