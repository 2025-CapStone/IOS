//
//  KeyboardAdaptive.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/30/25.
//


import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
  @State private var keyboardHeight: CGFloat = 0
  
  private let keyboardWillShow = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .compactMap { notification in
      notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
    .map { rect in
      rect.height
    }
  
  private let keyboardWillHide = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillHideNotification)
    .map { _ in CGFloat(0) }
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboardHeight)
      .onReceive(
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
      ) { height in
        withAnimation(.easeInOut) {
          self.keyboardHeight = height
        }
      }
  }
}

extension View {
  func keyboardAdaptive() -> some View {
    ModifiedContent(content: self, modifier: KeyboardAdaptive())
  }
}

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
