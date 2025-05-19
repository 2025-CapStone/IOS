//
//  SelectedScheduleListView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/16/25.
//

import SwiftUI

struct SelectedScheduleListView: View {
    let events: [Event]
    let selectedDate: Date
    @Binding var selectedEvent: Event?
    @Binding var showPopup: Bool

    var filteredEvents: [Event] {
        events.filter { Calendar.current.isDate($0.startTime, inSameDayAs: selectedDate) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if filteredEvents.isEmpty {
                Text("일정이 없습니다.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filteredEvents) { event in
                            SelectedScheduleListViewCell(event: event) { selected in
                                selectedEvent = selected
                                showPopup = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
