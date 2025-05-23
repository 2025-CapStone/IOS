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
    let isDisabled: Bool

    var isSelected: Bool { selectedId == id }

    var body: some View {
        Button(action: {
            if !isDisabled {
                callback(id)
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isDisabled ? .gray : (isSelected ? .white : .black))
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(isSelected ? Color(hex:"#8ce366").opacity(0.9) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color(hex:"#8ce366").opacity(0.5) : .clear, lineWidth: 1)
                )
                .cornerRadius(15)
                .shadow(color: isSelected ? .clear : .clear, radius: 2, x: 0, y: 2)
        }
        .disabled(isDisabled)
    }
}
