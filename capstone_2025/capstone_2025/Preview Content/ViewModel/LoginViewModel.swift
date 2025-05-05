//import Foundation
//import Combine
////
////final class LoginViewModel: ObservableObject {
////    @Published var phoneNumber: String = ""
////    @Published var password: String = ""
////    @Published var isLoading: Bool = false
////    @Published var errorMessage: String?
////    @Published var isSuccess: Bool = false
////    @Published var showErrorAlert: Bool = false
////
////    private let loginUseCase: LoginUseCase
////    private let networkService: RetryingNetworkService = AppDIContainer.shared.retryingNetworkService
////
////
////    init(loginUseCase: LoginUseCase) {
////        self.loginUseCase = loginUseCase
////    }
////
////    func login() {
////        isLoading = true
////        errorMessage = nil
////        showErrorAlert = false
////
////        _ = loginUseCase.execute(phoneNumber: phoneNumber, password: password) { [weak self] result in
////            DispatchQueue.main.async {
////                self?.isLoading = false
////                
////                switch result {
//////                case .success(let user):
//////                    self?.isSuccess = true
//////                    self?.storeTokensIfAvailable()
//////                    AppState.shared.userId = user.id
//////                    AppState.shared.isLoggedIn = true
////                case .success(let dto):
////                    TokenStorage.shared.accessToken = dto.accessToken
////                    TokenStorage.shared.refreshToken = dto.refreshToken
////                    AppState.shared.userId = dto.userId
////                    AppState.shared.isLoggedIn = true
////                    self?.storeTokensIfAvailable()
////                case .failure(let error):
////                    self?.errorMessage = error.localizedDescription
////                    self?.showErrorAlert = true
////                }
////            }
////        }
////    }
////    
////    
////
//////    func logout() {
//////        UserDefaults.standard.removeObject(forKey: "accessToken")
//////        UserDefaults.standard.removeObject(forKey: "refreshToken")
//////        AppState.shared.userId = nil
//////        AppState.shared.isLoggedIn = false
//////    }
////    
////    func logout() {
////        networkService.logout { success in
////            if success {
////                AppState.shared.userId = nil
////                AppState.shared.isLoggedIn = false
////            } else {
////                self.errorMessage = "서버 로그아웃에 실패했습니다."
////                self.showErrorAlert = true
////            }
////        }
////    }
////
////
////    private func storeTokensIfAvailable() {
////        guard let accessToken = TokenStorage.shared.accessToken,
////              let refreshToken = TokenStorage.shared.refreshToken else {
////            return
////        }
////        UserDefaults.standard.set(accessToken, forKey: "accessToken")
////        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
////    }
////}
////
//////import Foundation
//////import Combine
//////
//////final class LoginViewModel: ObservableObject {
//////    @Published var phoneNumber: String = ""
//////    @Published var password: String = ""
//////    @Published var isLoading: Bool = false
//////    @Published var errorMessage: String?
//////    @Published var isSuccess: Bool = false
//////
//////    private let loginUseCase: LoginUseCase
//////
//////    init(loginUseCase: LoginUseCase) {
//////        self.loginUseCase = loginUseCase
//////    }
//////
//////    func login() {
//////        isLoading = true
//////        errorMessage = nil
//////
//////        _ = loginUseCase.execute(phoneNumber: phoneNumber, password: password) { [weak self] result in
//////            DispatchQueue.main.async {
//////                self?.isLoading = false
//////                switch result {
//////                case .success:
//////                    self?.isSuccess = true
//////                case .failure(let error):
//////                    self?.errorMessage = error.localizedDescription
//////                }
//////            }
//////        }
//////    }
//////}
//
//
//final class LoginViewModel: ObservableObject {
//    @Published var phoneNumber: String = ""
//    @Published var password: String = ""
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//    @Published var isSuccess: Bool = false
//    @Published var showErrorAlert: Bool = false
//
//    private let loginUseCase: LoginUseCase
//    private let networkService: RetryingNetworkService = AppDIContainer.shared.retryingNetworkService
//
//    init(loginUseCase: LoginUseCase) {
//        self.loginUseCase = loginUseCase
//    }
//
//    func login() {
//        isLoading = true
//        errorMessage = nil
//        showErrorAlert = false
//
//        _ = loginUseCase.execute(phoneNumber: phoneNumber, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//
//                switch result {
//                case .success(let dto):
//                    TokenStorage.shared.accessToken = dto.accessToken
//                    TokenStorage.shared.refreshToken = dto.refreshToken
//
//                    // ✅ userId → User(id:) 구조로 변경
//                    let user = User(id: dto.userId)
//                    AppState.shared.user = user
//                    AppState.shared.isLoggedIn = true
//                    self?.isSuccess = true
//
//                    self?.storeTokensIfAvailable()
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                    self?.showErrorAlert = true
//                }
//            }
//        }
//    }
//
//    func logout() {
//        networkService.logout { [weak self] success in
//            DispatchQueue.main.async {
//                if success {
//                    AppState.shared.user = nil       // ✅ user nil 처리
//                    AppState.shared.isLoggedIn = false
//                } else {
//                    self?.errorMessage = "서버 로그아웃에 실패했습니다."
//                    self?.showErrorAlert = true
//                }
//            }
//        }
//    }
//
//    private func storeTokensIfAvailable() {
//        guard let accessToken = TokenStorage.shared.accessToken,
//              let refreshToken = TokenStorage.shared.refreshToken else {
//            return
//        }
//        UserDefaults.standard.set(accessToken, forKey: "accessToken")
//        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
//    }
//}
