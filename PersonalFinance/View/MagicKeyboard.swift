//
//  MagicKeyboard.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//

import SwiftUI
import Combine


struct MagicKeyboard: ViewModifier {
    
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        return content
            .offset( y: -keyboardHeight)
            .onAppear(perform: handleKeyboardEvents)
    }
    
    private func handleKeyboardEvents() {
        
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap {  $0.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect }
            .map{ $0.height}
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))

        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { _ in CGRect.zero }
            .map { $0.height }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
    }
}


extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: MagicKeyboard())
    }
}
