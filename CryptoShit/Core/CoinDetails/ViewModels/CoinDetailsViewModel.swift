import Foundation
import Combine

class CoinDetailsViewModel: ObservableObject {
	
	@Published var overviewStatistics: [StatisticModel] = []
	@Published var additionalDetailsStatistics: [StatisticModel] = []
	@Published var description: String?
	@Published var coin: CoinModel
	
	private let coinDetailsDataService: CoinDetailsDataService
	private var cancellables = Set<AnyCancellable>()

	init(coin: CoinModel) {
		self.coin = coin
		self.coinDetailsDataService = CoinDetailsDataService(coin: coin)
		self.addSubscribers()
	}
	
	private func addSubscribers() {
		coinDetailsDataService.$coinDetailsData
			.combineLatest($coin)
			.map(mapDataToStatistics)
			.sink { [weak self] returnedarrays in
				self?.overviewStatistics = returnedarrays.overview
				self?.additionalDetailsStatistics = returnedarrays.additionalDetails
				self?.description = returnedarrays.description
			}
			.store(in: &cancellables)
	}
	
	private func mapDataToStatistics(coinDetailModel: CoinDetailsModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additionalDetails: [StatisticModel], description: String) {
		let overviewArray = createOverviewArray(coinModel: coinModel)
		let additionalStatisticsArray = createAdditionalDetailsArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
		let description = getDescription(coinDetailModel: coinDetailModel)
		
		return (overviewArray, additionalStatisticsArray, description)
	}
	
	func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
		let priceStat = StatisticModel(
			title: "Current Price",
			value: coinModel.currentPrice.asCurrency(),
			percentageChange: coinModel.priceChangePercentage24H)
		
		let marketCapStat = StatisticModel(
			title: "Market Capitalization",
			value: coinModel.marketCap?.formattedWithAbbreviations() ?? "",
			percentageChange: coinModel.marketCapChangePercentage24H)
		
		let rankStat = StatisticModel(
			title: "Rank",
			value: "\(coinModel.rank)")

		let volumeStat = StatisticModel(
			title: "Volume",
			value: coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
		
		let overviewArray: [StatisticModel] = [
			priceStat, marketCapStat, rankStat, volumeStat
		]
		
		return overviewArray
	}
	
	func createAdditionalDetailsArray(coinDetailModel: CoinDetailsModel?, coinModel: CoinModel) -> [StatisticModel] {
		let highValue24 = StatisticModel(
			title: "24h High",
			value: coinModel.high24H?.asCurrencyShort() ?? "")
		
		let lowValue24 = StatisticModel(
			title: "24h Low",
			value: coinModel.low24H?.asCurrencyShort() ?? "")
		
		let priceChange24 = StatisticModel(
			title: "24h Price Change",
			value: coinModel.priceChange24H?.asCurrency() ?? "",
			percentageChange: coinModel.priceChangePercentage24H)
		
		let marketCapChange24 = StatisticModel(
			title: "24h Market Cap Change",
			value: coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "",
			percentageChange: coinModel.marketCapChangePercentage24H)
		
		let additionalStatisticsArray: [StatisticModel] = [
			highValue24, lowValue24, priceChange24, marketCapChange24
		]
		
		return additionalStatisticsArray
	}
	
	func getDescription(coinDetailModel: CoinDetailsModel?) -> String {
		guard
			let description = coinDetailModel?.description?.en else { return ""}
		return description
	}
}
