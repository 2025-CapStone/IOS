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
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isDisabled ? .gray : (isSelected ? .white : .black))
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
        .disabled(isDisabled)
    }
}
