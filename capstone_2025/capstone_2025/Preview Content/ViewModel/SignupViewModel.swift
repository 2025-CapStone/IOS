import Foundation
import Combine

final class SignupViewModel: ObservableObject {

    // Input
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var region: String = ""
    @Published var gender: User.Gender = .male
    @Published var birthDate: Date = Date()
    @Published var career: String = ""

    // Output
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false

    private let signupUseCase: SignupUseCase
    private var cancellables = Set<AnyCancellable>()

    init(signupUseCase: SignupUseCase) {
        self.signupUseCase = signupUseCase
    }

    func signup() {
        guard let careerInt = Int(career) else {
            errorMessage = "구력은 숫자로 입력해주세요."
            return
        }

        let user = User(
            name: name,
            gender: gender,
            birthDate: birthDate,
            region: region,
            phoneNumber: phoneNumber,
            password: password,
            career: careerInt
        )

        isLoading = true
        errorMessage = nil

        _ = signupUseCase.execute(
            requestValue: SignupRequestValue(user: user)
        ) { [weak self] result in
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
