//
//  chekCell.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/23/25.
//


import SwiftUICore
// ✅ 상태별 색상 및 텍스트 컬러 속성 추가
extension CellState {
    var color: Color {
        switch self {
        case .isSelected: return Color(hex:"#8CE366").opacity(0.9)
        case .isUnSelected: return Color.white.opacity(0.5)
        case .hasEvent: return Color(hex:"#8ce366").opacity(0.2)
        }
    }

    var borderColor: Color {
        switch self {
        case .isSelected: return .clear
        case .hasEvent: return .clear
        case .isUnSelected: return .clear
        }
    }

    var textColor: Color {
        switch self {
        case .isSelected: return .white
        case .hasEvent : return .white
        default: return .gray
        }
    }
}

enum CellState : String, CaseIterable, Identifiable {
    case isSelected
    case isUnSelected
    case hasEvent

    var id: Int { self.hashValue }
} 
