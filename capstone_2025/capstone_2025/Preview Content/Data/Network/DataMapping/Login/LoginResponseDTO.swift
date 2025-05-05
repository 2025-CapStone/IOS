//
//  LoginResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//

import Foundation


// MARK: - LoginResponseDTO
//
//  LoginResponseDTO.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/2/25.
//
//
//import Foundation
//
//// MARK: - LoginResponseDTO
//
//struct LoginResponseDTO: Decodable {
//    let userId: String
//    let userName: String
//    let accessToken: String
//    let refreshToken: String
//}
//
//// MARK: - Mapping to Domain User
//
//extension LoginResponseDTO {
//    func toDomain() -> User {
//        return User(id: userId)
//    }
//}

//
//struct LoginResponseDTO: Decodable {
//    let user: UserDTO
//    let accessToken: String
//    let refreshToken: String
//    let userId: Int
//
//    struct UserDTO: Decodable {
//        let userName: String
//        let gender: String
//        let birthDate: String
//        let region: String
//        let userTel: String
//        let password: String
//        let career: Int
//
//        func toDomain() -> User {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            return User(
//                name: userName,
//                gender: gender == "MALE" ? .male : .female,
//                birthDate: formatter.date(from: birthDate) ?? Date(),
//                region: region,
//                phoneNumber: userTel,
//                password: password,
//                career: career
//            )
//        }
//    }
//}
