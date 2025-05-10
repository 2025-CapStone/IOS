//
//  EventListViewModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/5/25.
//


import Foundation
import Combine
import Alamofire

final class SignupViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var region: String = ""
    @Published var gender: SignupUser.Gender = .male
    @Published var birthDate: Date = Date()
    @Published var career: String = ""

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false

    func signup() {
        guard let careerInt = Int(career) else {
            errorMessage = "구력은 숫자로 입력해주세요."
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthDateString = formatter.string(from: birthDate)

        let signupData: [String: Any] = [
            "userName": name,
            "userTel": phoneNumber,
            "password": password,
            "region": region,
            "gender": gender == .male ? "MALE" : "FEMALE",
            "birthDate": birthDateString,
            "career": careerInt
        ]

        isLoading = true
        errorMessage = nil

        Task {
            do {
                _ = try await UnsecuredAPI.shared.signup(signupData: signupData)
                DispatchQueue.main.async {
                    self.isSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

