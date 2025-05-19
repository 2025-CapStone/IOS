//
//  SelectedScheduleListViewCell.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/16/25.
//
import SwiftUI
struct SelectedScheduleListViewCell: View {
    let event: Event
    let onSelect: (Event) -> Void

    var body: some View {
        Button(action: {
            onSelect(event)
        }) {
            VStack(alignment: .leading, spacing: 6) {
                Text(event.startTime.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)

                Text(event.description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 180)
    }
}
