//
//  ClubJoinState.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//

enum ParticipantState {
    case notParticipated
    case GuestParticipated
    case GuestNotParticipated
    case Participated
    
    var buttonText: String {
        switch self {
        case .notParticipated:        return "참석하기"
        case .GuestParticipated:  return "게스트로 참석"
        case .GuestNotParticipated:    return "게스트로 참가하기"
        case .Participated: return "참석됨"

        }
    }
    
    var isButtonDisabled: Bool {
        switch self {
        case .notParticipated,.GuestNotParticipated:        return false
        case .GuestParticipated,.Participated: return true
        }
    }
}
