//
//  LoginViewModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


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
                AppState.shared.user = User(id: response.userId, joinedClub: [])
                AppState.shared.isLoggedIn = true

                DispatchQueue.main.async {
                    
                    self.isSuccess = true
                    print("🔹 로그인 성공 (User: \(AppState.shared.user)")
                    print("🔹 로그인 성공 (refreshToken: \(SessionStorage.shared.refreshToken)")
                    print("로그인 초기 joinedClub \(AppState.shared.user!.joinedClub)")
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
        guard let refreshToken = SessionStorage.shared.refreshToken else {
            print("[Logout] ❌ RefreshToken 없음 - 로그아웃 요청 불가")
            return
        }

        Task {
            //do {
                let data = try await SecuredAPI.shared.logout(refreshToken: refreshToken)
                print(data)
                if let message = String(data: data, encoding: .utf8) {
                    print("[Logout] ✅ 서버 응답: \(message)")
                }

                // ✅ 상태 초기화
                DispatchQueue.main.async {
                    AppState.shared.user = nil
                    AppState.shared.isLoggedIn = false
                    SessionStorage.shared.accessToken = nil
                    SessionStorage.shared.refreshToken = nil
                    self.isSuccess = false
                }
            //} catch {
             //   print("[Logout] ❌ 오류: \(error.localizedDescription)")
            //}
        }
    }

}

