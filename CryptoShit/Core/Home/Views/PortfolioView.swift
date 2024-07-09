//
//  PortfolioView.swift
//  CryptoShit
//
//  Created by Екатерина Кузмичева on 09.07.2024.
//

import SwiftUI

struct PortfolioView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject private var vm: HomeViewModel
	@State private var selectedCoin: CoinModel? = nil
	@State private var quantityText: String = ""
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 0) {
					SearchBarView(searchText: $vm.searchText)
					coinLogoList
					
					if selectedCoin != nil {
						portfolioInputSection
					}
				}
			}
			.navigationTitle("Edit Portfolio")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					XmarkButtonView()
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button(action: {
						savedButtonPressed()
						dismiss()
					}, label: {
						Text("Save".uppercased())
							.opacity(
								withAnimation(.easeIn) {
									selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0
								}
							)
					})
				}
			}
			.onChange(of: vm.searchText) { oldValue, newValue in
				if newValue == "" {
					unselectCoin()
				}
			}
		}
	}
}

extension PortfolioView {
	private var coinLogoList: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: 10) {
				ForEach(vm.allCoins) { coin in
					CoinLogoView(coin: coin)
						.frame(width: 75)
						.padding(4)
						.onTapGesture {
							withAnimation(.easeIn) {
								selectedCoin = coin
							}
						}
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color.background)
								.stroke(selectedCoin?.id == coin.id ? Color.theme.accent : Color.clear)
						)
				}
				.scrollIndicators(.hidden)
			}
			.padding(.vertical, 4)
			.padding(.leading)
		}
	}
	
	private var portfolioInputSection: some View {
		VStack(spacing: 20) {
			HStack {
				Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
				Spacer()
				Text("\(selectedCoin?.currentPrice.asCurrency() ?? "")")
			}
			Divider()
			HStack {
				Text("Amount holding:")
				Spacer()
				TextField("1.4", text: $quantityText)
					.multilineTextAlignment(.trailing)
					.keyboardType(.decimalPad)
			}
			Divider()
			HStack {
				Text("Current value:")
				Spacer()
				withAnimation {
					Text(getCurrentValue().asCurrencyShort())
				}
			}
		}
		.padding()
		.font(.headline)
	}
	
	private func getCurrentValue() -> Double {
		if let quantity = Double(quantityText) {
			return withAnimation {
				quantity * (selectedCoin?.currentPrice ?? 0)
			}
		}
		return 0
	}
	
	private func savedButtonPressed() {
		guard
			let coin = selectedCoin,
			let amount = Double(quantityText)
		else { return }
		vm.updatePortfolio(coin: coin, amount: amount)
		
		withAnimation(.easeIn) {
			unselectCoin()
		}
	}
	
	private func unselectCoin() {
		selectedCoin = nil
		vm.searchText = ""
		quantityText = ""
	}
}

#Preview {
	PortfolioView()
		.environmentObject(DeveloperPreview.instance.homeVM)
}
