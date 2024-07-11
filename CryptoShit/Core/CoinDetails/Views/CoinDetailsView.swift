import SwiftUI

struct CoinDetailsView: View {
	var coin: CoinModel
	@StateObject private var vm: CoinDetailsViewModel
	private let columns: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	private let spacing: CGFloat = 30
	
	init(coin: CoinModel) {
		self.coin = coin
		_vm = StateObject(wrappedValue: CoinDetailsViewModel(coin: coin))
		print("CoinDetailView initialized for \(coin.name)")
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				Text("")
					.frame(height: 150)
				
				overviewTitle
				Divider()
				overviewStats
				
				additionalDetailsTitle
				Divider()
				additionalDetailsStats
			}
		}
		.navigationTitle(vm.coin.name)
	}
}

struct CoinDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			CoinDetailsView(coin: DeveloperPreview.instance.coin)
		}
	}
}

extension CoinDetailsView {
	private var overviewTitle: some View {
		Text("Overview")
			.font(.title)
			.bold()
			.foregroundStyle(Color.theme.accent)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading)
	}
	private var overviewStats: some View {
		LazyVGrid(
			columns: columns,
			alignment: .leading,
			spacing: spacing,
			content: {
				ForEach(vm.overviewStatistics) { stat in
					StatisticsView(stat: stat)
				}
			})
		.padding(.leading)
	}
	
	private var additionalDetailsTitle: some View {
		Text("Additional details")
			.font(.title)
			.bold()
			.foregroundStyle(Color.theme.accent)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading)
	}
	
	private var additionalDetailsStats: some View {
		LazyVGrid(
			columns: columns,
			alignment: .leading,
			spacing: spacing,
			content: {
				ForEach(vm.additionalDetailsStatistics) { stat in
					StatisticsView(stat: stat)
				}
			})
		.padding(.leading)
	}
}
