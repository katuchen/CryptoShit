import Foundation
import Combine

class HomeViewModel: ObservableObject {
	
	@Published var statistics: [StatisticModel] = []
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	@Published var searchText = ""
	
	private let coinDataService = CoinDataService()
	private let marketDataService = MarketDataService()
	private let portfolioDataService = PortfolioDataService()
	private var cancellables = Set<AnyCancellable>()
	
	init() {
		addSubscribers()
	}
	
	func addSubscribers() {
		
		// Обновляет список коинов по тексту в запросе
		$searchText
			.combineLatest(coinDataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
		
		// Обновляет даныне о рынке
		marketDataService.$marketData
			.map(mapGlobalMarketData)
			.sink { [weak self] returnedStats in
				self?.statistics = returnedStats
			}
			.store(in: &cancellables)
		
		// Обновляет данные портфеля
		$allCoins
			.combineLatest(portfolioDataService.$savedEntities)
			.map { coinModels, portfolioEntities -> [CoinModel] in
				coinModels
					.compactMap { currentCoin -> CoinModel? in
						guard
							let entity = portfolioEntities.first(where: { $0.coinID == currentCoin.id }) else {
							return nil
						}
						return currentCoin.updateHoldings(amount: entity.amount)
					}
			}
			.sink { [weak self] returnedCoins in
				self?.portfolioCoins = returnedCoins
			}
			.store(in: &cancellables)
	}
	
	func updatePortfolio(coin: CoinModel, amount: Double) {
		portfolioDataService.updatePortfolio(coin: coin, amount: amount)
	}
	
	private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
		guard !text.isEmpty else {
			return startingCoins
		}
		
		let lowercasedText = text.lowercased()
		
		return startingCoins.filter { coin -> Bool in
			return coin.name.lowercased().contains(lowercasedText)
			|| coin.symbol.lowercased().contains(lowercasedText)
			|| coin.id.lowercased().contains(lowercasedText)
		}
	}
	
	private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
		var stats: [StatisticModel] = []
		
		guard let data = marketDataModel else {
			return stats
		}
		let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
		let volume = StatisticModel(title: "24h Volume", value: data.volume)
		let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
		let portfolio = StatisticModel(title: "Portfolio value", value: "$0.00", percentageChange: 0)
		stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
		return stats
	}
}
