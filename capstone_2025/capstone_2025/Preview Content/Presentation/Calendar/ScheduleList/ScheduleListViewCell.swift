//
//  ScheduleListViewCell.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import SwiftUI

struct ScheduleListViewCell: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text("시작")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(event.startTime.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            HStack(spacing: 4) {
                Text("종료")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(event.endTime.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Text(event.description)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // ✅ 셀 최대 너비로 확장
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.15), radius: 2, x: 0, y: 2)
        )
    }
}


struct ScheduleListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListViewCell(event: dummyEvent)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(.systemGroupedBackground))
    }

    static var dummyEvent: Event {
        Event(
            eventId: 101,
            clubId: 1,
            startTime: Date(),
            endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
            description: "SwiftUI 스터디 - Combine 기초"
        )
    }
}
