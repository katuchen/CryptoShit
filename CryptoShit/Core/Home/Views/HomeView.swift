import SwiftUI

struct HomeView: View {
	
	@EnvironmentObject private var vm : HomeViewModel
	@State private var showPortfolio = false
	@State private var showPortfolioView = false
	
	var body: some View {
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
			Text("Coin")
			Spacer()
			if showPortfolio {
				Text("Holdings")
			}
			Text("Price")
				.frame(width: (UIScreen.current?.bounds.width ?? 0) / 3.5)
		}
	}
	
	private var allCoinsList: some View {
		List {
			ForEach(vm.allCoins) { coin in
				CoinRowView(coin: coin, showHoldingsColumn: false)
					.listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
			}
		}
		.listStyle(.plain)
	}
	
	private var portfolioCoinsList: some View {
		List {
			ForEach(vm.allCoins) { coin in
				CoinRowView(coin: coin, showHoldingsColumn: true)
					.listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
			}
		}
		.listStyle(.plain)
	}
}
