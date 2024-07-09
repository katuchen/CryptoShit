//
//  HomeStatisticsView.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 07.07.2024.
//

import SwiftUI

struct HomeStatisticsView: View {
	@EnvironmentObject private var vm: HomeViewModel
	@Binding var showPortfolio: Bool
    var body: some View {
		HStack {
			ForEach(vm.statistics) { stat in
				StatisticsView(stat: stat)
					.frame(width: UIScreen.main.bounds.width / 3)
			}
		}
		.frame(width: UIScreen.main.bounds.width, 
			   alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
	HomeStatisticsView(showPortfolio: .constant(false))
		.environmentObject(DeveloperPreview.instance.homeVM)
}
