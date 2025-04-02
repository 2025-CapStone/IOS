//
//  LoginResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//

import Foundation


// MARK: - LoginResponseDTO

struct LoginResponseDTO: Decodable {
    let user: UserDTO

    struct UserDTO: Decodable {
        let userName: String
        let gender: String
        let birthDate: String
        let region: String
        let userTel: String
        let password: String
        let career: Int

        func toDomain() -> User {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return User(
                name: userName,
                gender: gender == "MALE" ? .male : .female,
                birthDate: formatter.date(from: birthDate) ?? Date(),
                region: region,
                phoneNumber: userTel,
                password: password,
                career: career
            )
        }
    }
}
