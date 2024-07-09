//
//  CryptoShitApp.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 06.07.2024.
//

import SwiftUI

@main
struct CryptoShitApp: App {
	@StateObject private var vm = HomeViewModel()
	
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				HomeView()
			}
			.environmentObject(vm)
        }
    }
}
