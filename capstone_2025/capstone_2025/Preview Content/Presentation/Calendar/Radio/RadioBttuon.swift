//
//  RadioBttuon.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/15/25.
//

import SwiftUI
//
//struct RadioButton: View {
//    let id: Int
//    let title: String
//    let callback: (Int) -> ()
//    let selectedId: Int
//
//    var isSelected: Bool { selectedId == id }
//
//    var body: some View {
//        Button(action: {
//            callback(id)
//        }) {
//            Text(title)
//                .font(.system(size: 10, weight: .bold))
//                .padding(.vertical, 8)
//                .padding(.horizontal, 12)
//                .foregroundColor(isSelected ? .white : Color.gray)
//                .background(isSelected ? Color.blue : Color(UIColor.systemGray5))
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.blue, lineWidth: 1)
//                )
//        }
//    }
//}
import SwiftUI

struct RadioButton: View {
    let id: Int
    let title: String
    let callback: (Int) -> ()
    let selectedId: Int

    var isSelected: Bool { selectedId == id }

    var body: some View {
        Button(action: {
            callback(id)
        }) {
            Text(title)
                .font(.system(size: 14, weight: .semibold)) // ✅ 홈과 동일한 스타일
                .foregroundColor(isSelected ? .white : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(isSelected ? Color.green : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(color: isSelected ? Color.black.opacity(0.1) : .clear, radius: 2, x: 0, y: 2)
        }
    }
}
