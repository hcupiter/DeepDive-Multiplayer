//
//  OxygenBar.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 27/04/24.
//

import SwiftUI

struct OxygenBar: View {
    @Binding var current: CGFloat
    @Binding var max: CGFloat

    var body: some View {
        ProgressView(value: current, total: max)
            .tint(Color.green)
            .scaleEffect(x: 1, y: 5)
            .padding()
    }
}

#Preview {
    OxygenBar(current: .constant(50), max: .constant(100))
}
