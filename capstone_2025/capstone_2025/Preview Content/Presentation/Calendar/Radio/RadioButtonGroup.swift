
import SwiftUI

enum FilterOption: String, CaseIterable, Identifiable {
    case selectedClub = "선택한 클럽"
    case joinedClubs = "가입 클럽"
    case checkedEvents = "참석 체크한"

    var id: Int { self.hashValue }
}
struct RadioButtonGroup: View {
    @Binding var selectedOption: FilterOption
    let disableSelectedClub: Bool
    let callback: (FilterOption, FilterOption) -> ()
    

    private func radioGroupCallback(_ new: FilterOption) {
        let previous = selectedOption
        selectedOption = new
        callback(previous, new)
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(FilterOption.allCases) { option in
                RadioButton(
                    id: option.id,
                    title: option.rawValue,
                    callback: { _ in radioGroupCallback(option) },
                    selectedId: selectedOption.id,
                    isDisabled: (option == .selectedClub && disableSelectedClub)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
struct RadioButtonGroup_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedOption: FilterOption = .joinedClubs

        var body: some View {
            RadioButtonGroup(
                selectedOption: $selectedOption,
                disableSelectedClub: true // 또는 false로 변경 가능
            ) { old, new in
                print("이전: \(old.rawValue), 현재: \(new.rawValue)")
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
