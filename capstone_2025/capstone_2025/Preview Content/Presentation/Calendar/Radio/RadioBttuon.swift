//
//  RadioBttuon.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/15/25.
//

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
                .font(.system(size: 10, weight: .bold))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .foregroundColor(isSelected ? .white : Color.gray)
                .background(isSelected ? Color.blue : Color(UIColor.systemGray5))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}
