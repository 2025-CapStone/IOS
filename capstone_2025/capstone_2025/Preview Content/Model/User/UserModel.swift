//
//  UserModel.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 3/26/25.
//

import Foundation

struct UserModel: Identifiable
{
    let id: String = UUID().uuidString
    let displayName: String
    let userName : String
    let followerCount: Int
    let isChecked: Bool
}




