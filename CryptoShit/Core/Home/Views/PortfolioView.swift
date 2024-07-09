//
//  PortfolioView.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 09.07.2024.
//

import SwiftUI

struct PortfolioView: View {
	@EnvironmentObject private var vm: HomeViewModel
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 0) {
					SearchBarView(searchText: $vm.searchText)
					ScrollView(.horizontal) {
						LazyHStack(spacing: 10) {
							ForEach(vm.allCoins) { coin in
								CoinLogoView(coin: coin)
									.frame(width: 75)
									.background(
									RoundedRectangle(cornerRadius: 10)
										.stroke(Color.theme.secondaryText, lineWidth: 0.5)
									)
							}
							.scrollIndicators(.hidden)
						}
						.padding(.vertical, 4)
						.padding(.leading)
					}
				}
			}
			.navigationTitle("Edit Portfolio")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					XmarkButtonView()
				}
			}
		}
	}
}

#Preview {
	PortfolioView()
		.environmentObject(DeveloperPreview.instance.homeVM)
}
