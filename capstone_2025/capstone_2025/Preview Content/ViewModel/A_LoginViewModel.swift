import Foundation
import Combine
import Alamofire

final class LoginViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false
    @Published var showErrorAlert: Bool = false

    func login() {
        isLoading = true
        errorMessage = nil
        showErrorAlert = false

        let loginData: [String: Any] = [
            "userTel": phoneNumber,
            "password": password
        ]

        Task {
            do {
                let data = try await UnsecuredAPI.shared.login(loginData: loginData)
                let response = try JSONDecoder().decode(LoginResponseDTO.self, from: data)

                // ✅ 토큰 저장
                SessionStorage.shared.accessToken = response.accessToken
                SessionStorage.shared.refreshToken = response.refreshToken

                // ✅ 유저 정보 저장
                AppState.shared.user = User(id: response.userId)
                AppState.shared.isLoggedIn = true

                DispatchQueue.main.async {
                    self.isSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    func logout() {
        AppState.shared.user = nil
        AppState.shared.isLoggedIn = false
        SessionStorage.shared.accessToken = nil
        SessionStorage.shared.refreshToken = nil
    }
}

