//
//  CircleButtonAnimationView.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 06.07.2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
	
	@Binding var animate : Bool
	
    var body: some View {
        Circle()
			.stroke(lineWidth: 3.0)
			.scale(animate ? 1.0 : 0.0)
			.opacity(animate ? 0.0 : 0.7)
			.animation(animate ? .easeOut(duration: 1.0) : .none, value: animate)
    }
}

#Preview {
	CircleButtonAnimationView(animate: .constant(false))
		.frame(width: 100, height: 100)
}
