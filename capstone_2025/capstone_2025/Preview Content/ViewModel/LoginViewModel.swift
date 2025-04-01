import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSuccess: Bool = false

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() {
        isLoading = true
        errorMessage = nil

        _ = loginUseCase.execute(phoneNumber: phoneNumber, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isSuccess = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
