//
//  BlankView.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 03/01/2022.
//

import SwiftUI

struct BlankView: View {
    
    var bgColor: Color
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(bgColor: .black)
            .opacity(0.5)
    }
}
