//
//  ControlButton.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 25/04/24.
//

import SwiftUI

struct ControlButton: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipped()
            .foregroundStyle(Color.white)
            .background(Color.secondary)
    }
}

#Preview {
    ControlButton(iconName: "arrowshape.up.fill")
}
