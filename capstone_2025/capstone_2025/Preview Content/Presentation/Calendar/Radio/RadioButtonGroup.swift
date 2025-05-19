//
//  RadioButtonGroup.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/15/25.
//
import SwiftUI

enum FilterOption: String, CaseIterable, Identifiable {
    case selectedClub = "선택한 클럽"
    case joinedClubs = "가입 클럽"
    case checkedEvents = "참석 체크한"

    var id: Int { self.hashValue }  // ForEach에서 사용
}
struct RadioButtonGroup: View {
    @State private var selectedOption: FilterOption = .selectedClub
    let callback: (FilterOption, FilterOption) -> ()

    private func radioGroupCallback(_ new: FilterOption) {
        let previous = selectedOption
        selectedOption = new
        callback(previous, new)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 20) {
                ForEach(FilterOption.allCases) { option in
                    RadioButton(
                        id: option.id, title: option.rawValue,
                        callback: { _ in radioGroupCallback(option) },
                        selectedId: selectedOption.id
                    )
                }
            }
        }
        .padding()
    }
}


struct RadioButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonGroup { old, new in
            print("이전: \(old.rawValue), 현재: \(new.rawValue)")
        }
        .previewLayout(.sizeThatFits)
    }
}
