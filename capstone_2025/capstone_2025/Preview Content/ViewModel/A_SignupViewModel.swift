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

    @Published var selectedRegion: String = ""
    @Published var selectedDistrict: String = ""
    @Published var allRegions: [Region] = []

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false

    init() {
        loadRegions()
    }

    func loadRegions() {
        
        guard let url = Bundle.main.url(forResource: "Region", withExtension: "json") else {
            print("[❌] regions.json 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Region].self, from: data)
            self.allRegions = decoded

            if let first = decoded.first {
                self.selectedRegion = first.name
                self.selectedDistrict = first.districts.first ?? ""
            }
        } catch {
            print("[❌] 행정구역 로딩 실패:", error)
        }
    }

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
            "region": "\(selectedRegion) \(selectedDistrict)",
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
