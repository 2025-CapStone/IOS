//
//  ClubJoinState.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


enum ClubJoinState {
    case notJoined
    case pendingApproval
    case alreadyJoined
    
    var buttonText: String {
        switch self {
        case .notJoined:        return "가입하기"
        case .pendingApproval:  return "가입 수락 대기중"
        case .alreadyJoined:    return "가입된 클럽"
        }
    }
    
    var isButtonDisabled: Bool {
        switch self {
        case .notJoined,.pendingApproval:        return false
        case .alreadyJoined: return true
        }
    }
}
