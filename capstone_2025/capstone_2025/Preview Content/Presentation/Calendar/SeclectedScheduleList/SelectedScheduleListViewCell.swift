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
            VStack(alignment: .leading, spacing: 4) {
                Text(event.startTime.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(event.description)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 180) // 적절한 너비
    }
}
