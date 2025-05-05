//
//  SignupUser.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/11/25.
//

import Foundation


struct SignupUser {
    enum Gender {
        case male
        case female
    }
    let name: String
    let gender: Gender
    let birthDate: Date
    let region: String
    let phoneNumber: String
    let password: String
    let career: Int
}
extension SignupUser.Gender {
    var rawValue: String {
        switch self {
        case .male: return "MALE"
        case .female: return "FEMALE"
        }
    }
}
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
