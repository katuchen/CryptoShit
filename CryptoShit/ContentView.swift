//
//  ContentView.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 06.07.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		ZStack {
			Color.theme.background
				.ignoresSafeArea()
			
			VStack (spacing: 30) {
				Text("Main text here!")
					.font(.title)
				Text("Accent text here!")
					.font(.headline)
					.foregroundStyle(Color.theme.accent)
				Text("Green text here!")
					.font(.headline)
					.foregroundStyle(Color.theme.green)
				Text("Red text here!")
					.font(.headline)
					.foregroundStyle(Color.theme.red)
				Text("Secondary text here!")
					.font(.subheadline)
					.foregroundStyle(Color.theme.secondaryText)
			}
		}
    }
}

#Preview {
    ContentView()
}
