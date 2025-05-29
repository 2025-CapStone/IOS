

import SwiftUI

struct SignUp: View {
    @EnvironmentObject var router: NavigationRouter
    @ObservedObject var viewModel: SignupViewModel
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack {
            Color(hex: "#f8f9fc")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }

            ScrollView {
                VStack(spacing: 20) {
                    Text("On Club")
                        .font(.custom("Comfortaa-Bold", size: 30))
                        .padding(.top, 30)

                    Group {
                        CustomTextField(title: "이름", text: $viewModel.name)
                        SecureTextField(title: "비밀번호", text: $viewModel.password)
                        CustomTextField(title: "전화번호 (예: 010-1234-5678)", text: $viewModel.phoneNumber)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("지역")
                                .font(.headline)
                                .foregroundColor(.black)

                            Picker("광역시/도", selection: $viewModel.selectedRegion) {
                                ForEach(viewModel.allRegions, id: \ .self) { region in
                                    Text(region.name).tag(region.name)
                                }
                            }
                            .onChange(of: viewModel.selectedRegion) { newValue in
                                if let region = viewModel.allRegions.first(where: { $0.name == newValue }) {
                                    viewModel.selectedDistrict = region.districts.first ?? ""
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            Picker("시/군/구", selection: $viewModel.selectedDistrict) {
                                if let selected = viewModel.allRegions.first(where: { $0.name == viewModel.selectedRegion }) {
                                    ForEach(selected.districts, id: \ .self) { district in
                                        Text(district).tag(district)
                                    }
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("성별")
                                .font(.headline)
                                .foregroundColor(.black)
                            Picker("성별", selection: $viewModel.gender) {
                                Text("남자").tag(SignupUser.Gender.male)
                                Text("여자").tag(SignupUser.Gender.female)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("생년월일")
                                .font(.headline)
                                .foregroundColor(.black)
                            DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                        }

                        CustomTextField(title: "구력 (연 단위 숫자)", text: $viewModel.career)
                    }
                    .padding(.horizontal, 30)

                    Button(action: {
                        viewModel.signup()
                        showAlert = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "#f5b800"))
                                .frame(height: 55)
                                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)

                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("가입하기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
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
                .padding(.bottom, 30)
            }
            .keyboardAdaptive()
        }
    }
}
struct CustomTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#333333"))

            TextField("", text: $text)
                .padding(12)
                .background(Color(hex: "#f8f9fc"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1.5))
                .cornerRadius(10)
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
    }
}

struct SecureTextField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#333333"))

            SecureField("", text: $text)
                .padding(12)
                .background(Color(hex: "#f8f9fc"))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1.5))
                .cornerRadius(10)
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
    }
}
struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(viewModel: AppDIContainer.shared.makeSignupViewModel())
            .environmentObject(NavigationRouter())

    }
}
#Preview {
    SignUp(viewModel: SignupViewModel())
        .environmentObject(NavigationRouter())
}
//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        _ = scanner.scanString("#") // '#' 제거
//        var rgb: UInt64 = 0
//        scanner.scanHexInt64(&rgb)
//
//        let r = Double((rgb >> 16) & 0xFF) / 255
//        let g = Double((rgb >> 8) & 0xFF) / 255
//        let b = Double(rgb & 0xFF) / 255
//
//        self.init(red: r, green: g, blue: b)
//    }
//}
