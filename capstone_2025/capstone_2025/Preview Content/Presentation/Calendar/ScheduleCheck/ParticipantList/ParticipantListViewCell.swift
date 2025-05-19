//
//  ParticipantListViewCell.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/19/25.
//


import SwiftUI

struct ParticipantListViewCell: View {
    let participant: Participant
    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(participant.name)
                        .font(.headline)
                    Text("경력: \(participant.career)년, 성별: \(participant.gender)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .sheet(isPresented: $showDetail) {
            ParticipantDetailView(participant: participant)
        }
    }
}
