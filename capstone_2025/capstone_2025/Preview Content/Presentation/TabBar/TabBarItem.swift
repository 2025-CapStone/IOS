//
//  TabBarItem.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//

import SwiftUICore


enum TabBarItem: Hashable {
    case home, likes, profile
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .likes: return "heart"
        case .profile: return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .likes: return "Likes"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .red
        case .likes: return .green
        case .profile: return .blue
        }
    }
    
    
}
