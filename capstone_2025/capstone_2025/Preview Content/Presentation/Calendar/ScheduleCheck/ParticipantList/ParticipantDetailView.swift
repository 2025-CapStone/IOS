//
//  ParticipantDetailView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import SwiftUI

struct ParticipantDetailView: View {
    let participant: Participant

    var body: some View {
        VStack(spacing: 20) {
            Text("이름: \(participant.name)")
                .font(.title)
            Text("성별: \(participant.gender)")
            Text("경력: \(participant.career)년")
            Text("게임 수: \(participant.gameCount ?? 0)회")
            if let last = participant.lastGamedAt {
                Text("마지막 경기: \(last.formatted())")
            }
            Spacer()
        }
        .padding()
    }
}
