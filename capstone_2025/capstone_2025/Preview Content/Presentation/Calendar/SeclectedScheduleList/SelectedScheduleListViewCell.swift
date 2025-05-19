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
            VStack(alignment: .leading) {
                Text(event.startTime.formatted(date: .omitted, time: .shortened))
                    .foregroundColor(.brown)
                Text(event.description)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
        }
    }
}
