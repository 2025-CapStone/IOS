//
//  User.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//

import Foundation


// MARK: - Domain User Entity (기준 참고용)

struct User {
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
