//
//  Untitled.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//
import Foundation
// MARK: - SignUpRequest DTO (Encodable)

struct SignUpRequestDTO: Encodable {
    let userName: String
    let userTel: String
    let password: String
    let region: String
    let gender: String
    let birthDate: String
    let career: Int
}

extension SignUpRequestDTO {
    init(_ user: SignupUser) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        self.userName = user.name
        self.userTel = user.phoneNumber
        self.password = user.password
        self.region = user.region
        self.gender = user.gender == .male ? "MALE" : "FEMALE"
        self.birthDate = formatter.string(from: user.birthDate)
        self.career = user.career
    }
}

