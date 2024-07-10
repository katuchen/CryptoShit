import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
	
	@Published var statistics: [StatisticModel] = []
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	@Published var searchText = ""
	@Published var sortOption: SortOption = .rank
	
	private let coinDataService = CoinDataService()
	private let marketDataService = MarketDataService()
	private let portfolioDataService = PortfolioDataService()
	private var cancellables = Set<AnyCancellable>()
	
	enum SortOption {
		case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
	}
	
	init() {
		addSubscribers()
	}
	
	func addSubscribers() {
		
		// Обновляет список коинов по тексту в запросе
		$searchText
			.combineLatest(coinDataService.$allCoins, $sortOption)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterAndSortCoins)
			.sink { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
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
				guard let self = self else { return }
				self.portfolioCoins = self.sortPortfolioCoins(coins: returnedCoins)
			}
			.store(in: &cancellables)
		
		// Обновляет даныне о рынке
		marketDataService.$marketData
			.combineLatest($portfolioCoins)
			.map(mapGlobalMarketData)
			.sink { [weak self] returnedStats in
				self?.statistics = returnedStats
			}
			.store(in: &cancellables)
	}
	
	func updatePortfolio(coin: CoinModel, amount: Double) {
		portfolioDataService.updatePortfolio(coin: coin, amount: amount)
	}
	
	private func filterAndSortCoins(text: String, startingCoins: [CoinModel], sort: SortOption) -> [CoinModel] {
		var filteredCoins = filterCoins(text: text, startingCoins: startingCoins)
		sortCoins(sort: sort, coins: &filteredCoins)
		return filteredCoins
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
	
	private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
		switch sort {
			case .rank, .holdings: 
				coins.sort(by: { $0.rank < $1.rank })
			case .rankReversed, .holdingsReversed:
				coins.sort(by: { $0.rank > $1.rank })
			case .price:
				coins.sort(by: { $0.currentPrice > $1.currentPrice })
			case .priceReversed:
				coins.sort(by: { $0.currentPrice < $1.currentPrice })
		}
	}
	
	private func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
		switch sortOption {
			case .holdings:
				return coins.sorted(by: { $0.currentHoldingValue > $1.currentHoldingValue })
			case .holdingsReversed:
				return coins.sorted(by: { $0.currentHoldingValue < $1.currentHoldingValue })
			default: 
				return coins
		}
	}
	
	private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
		var stats: [StatisticModel] = []
		
		guard let data = marketDataModel else {
			return stats
		}
		let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
		let volume = StatisticModel(title: "24h Volume", value: data.volume)
		let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
		
		let portfolioValue =
			portfolioCoins
			.map({ $0.currentHoldingValue })
			.reduce(0, +)
		
		let portfolioValue24hAgo =
		portfolioCoins
			.map { coin -> Double in
				let currentValue = coin.currentHoldingValue
				let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
				let previousValue = currentValue / (1 + percentageChange)
				return previousValue
		}
			.reduce(0, +)
		
		let percentageChange = (portfolioValue - portfolioValue24hAgo) / portfolioValue
		
		let portfolio = StatisticModel(
			title: "Portfolio value",
			value: portfolioValue.asCurrencyShort(),
			percentageChange: percentageChange)
		
		stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
		return stats
	}
	
	func reloadData() {
		coinDataService.getCoins()
		marketDataService.getMarketData()
		HapticManager.notification(type: .success)
	}
}
