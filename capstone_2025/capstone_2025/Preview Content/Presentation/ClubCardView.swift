////
////  ClubCardView.swift
////  capstone_2025
////
////  Created by ㅇㅇ ㅇ on 4/23/25.
////
//
//
//import SwiftUI
//
//struct ClubCardView: View {
//    let club: ClubResponseDTO
//
//    var body: some View {
//        NavigationLink(destination: club_intro(club: club)) {
//            VStack {
//                AsyncImage(url: URL(string: club.clubLogoURL!)) { image in
//                    image.resizable()
//                } placeholder: {
//                    Color.gray
//                }
//                .frame(height: 120)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//
//                Text(club.clubName)
//                    .font(.system(size: 16, weight: .bold))
//                    .foregroundColor(.black)
//            }
//            .frame(width: 170, height: 180)
//            .background(Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: 15))
//            .shadow(radius: 2)
//        }
//    }
//}
