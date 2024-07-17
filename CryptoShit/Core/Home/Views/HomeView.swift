import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject private var vm : HomeViewModel
	@State private var showPortfolio = false
	@State private var showPortfolioView = false
	@State private var sortCoin = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				// background layer
				Color.theme.background
					.ignoresSafeArea()
				
				// content layer
				VStack {
					homeHeader
					HomeStatisticsView(showPortfolio: $showPortfolio)
					SearchBarView(searchText: $vm.searchText)
					columnTitles
						.font(.caption)
						.foregroundStyle(Color.theme.secondaryText)
						.padding(.horizontal)
					if !showPortfolio {
						allCoinsList
							.transition(.move(edge: .leading))
					}
					if showPortfolio {
						portfolioCoinsList
							.transition(.move(edge: .trailing))
					}
					Spacer()
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		HomeView()
	}
	.environmentObject(DeveloperPreview.instance.homeVM)
}

extension HomeView {
	
	private var homeHeader: some View {
		HStack {
			CircleButtonView(iconName: showPortfolio ? "plus" : "info")
				.animation(.none, value: showPortfolio)
				.background(CircleButtonAnimationView(animate: $showPortfolio))
				.onTapGesture {
					if showPortfolio {
						showPortfolioView.toggle()
					}
				}
			Spacer()
			Text(showPortfolio ? "Portfolio" : "Live Prices")
				.font(.headline)
				.fontWeight(.heavy)
				.foregroundStyle(Color.theme.accent)
				.animation(.none, value: showPortfolio)
			Spacer()
			CircleButtonView(iconName: "chevron.right")
				.rotationEffect(Angle(degrees: showPortfolio ? -180 : 0))
				.onTapGesture {
					withAnimation(.spring) {
						showPortfolio.toggle()
					}
				}
				.sheet(isPresented: $showPortfolioView, content: {
					PortfolioView()
						.environmentObject(vm)
				})
		}
		.padding(.horizontal)
	}
	
	private var columnTitles: some View {
		HStack {
			HStack {
				Text("Coin")
				Image(systemName: "chevron.down")
					.opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0 )
					.rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
			}
			.onTapGesture {
				withAnimation(.smooth) {
					vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
				}
			}
			Spacer()
			if showPortfolio {
				HStack {
					Text("Holdings")
					Image(systemName: "chevron.down")
						.opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0 )
						.rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
				}
				.onTapGesture {
					withAnimation(.smooth) {
						vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
					}
				}
			}
			HStack {
				Text("Price")
				Image(systemName: "chevron.down")
					.opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0 )
					.rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
			}
			.frame(width: (UIScreen.current?.bounds.width ?? 0) / 3.5)
			.onTapGesture {
				withAnimation(.smooth) {
					vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
				}
			}
		}
	}
	
	private var allCoinsList: some View {
		List {
			ForEach(vm.allCoins) { coin in
				NavigationLink {
					LazyView(CoinDetailsView(coin: coin))
				} label: {
					CoinRowView(coin: coin, showHoldingsColumn: false)
						.listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
				}
				
			}
		}
		.refreshable {
			vm.reloadData()
		}
		.listStyle(.plain)
	}
	
	private var portfolioCoinsList: some View {
		List {
			ForEach(vm.portfolioCoins) { coin in
				NavigationLink {
					LazyView(CoinDetailsView(coin: coin))
				} label: {
					CoinRowView(coin: coin, showHoldingsColumn: true)
						.listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
				}
			}
			.onDelete(perform: delete)
		}
		.listStyle(.plain)
	}
	
	private func delete(at offsets: IndexSet) {
		vm.portfolioCoins.remove(atOffsets: offsets)
	}
}
