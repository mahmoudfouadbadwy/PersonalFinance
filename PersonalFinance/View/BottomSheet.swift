//
//  BotttomSheet.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 03/01/2022.
//

import SwiftUI

enum DragState {
    
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .dragging:
            return true
        case .inactive, .pressing:
            return false
        }
    }
    
}

struct BottomSheet<Content>: View where Content: View {
    
    @Binding private  var isShow: Bool
    @GestureState private var dragState = DragState.inactive
    private let content: () -> Content
    
    init(isShow: Binding<Bool>, content: @escaping () -> Content) {
        self._isShow = isShow
        self.content = content
    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer()
                
                HandleBar()
                
                ScrollView(.vertical) {
                    self.content()
                }
                .animation(nil)
                .background(Color.white)
                .cornerRadius(10, antialiased: true)
                .disabled(self.dragState.isDragging)
            }
            .offset(y: geometry.size.height/3 + self.dragState.translation.height)
            .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
            .edgesIgnoringSafeArea(.all)
            .gesture(DragGesture()
                        .updating(self.$dragState, body: { (value, state, transaction) in
                if value.translation.height > 0 {
                    state = .dragging(translation: value.translation)
                }
                
            }).onEnded({ (value) in
                if value.translation.height > geometry.size.height * 0.5 {
                    self.isShow = false
                }
            })
            )
        }
    }
}

struct HandleBar: View {
    var body: some View {
        Rectangle()
            .frame(width: 50, height: 5)
            .foregroundColor(Color(.systemGray5))
            .cornerRadius(10)
    }
}


struct BotttomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isShow : .constant(true)) {
            Text("hello")
        }
    }
}
