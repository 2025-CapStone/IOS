//
//  ClubEventContext.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/6/25.
//


final class ClubEventContext {
    static let shared = ClubEventContext()

    private init() { }

    var selectedClubId: Int?
    var selectedClubName: String?

}
