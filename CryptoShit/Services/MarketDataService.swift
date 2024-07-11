import Foundation
import Combine

class MarketDataService {
	
	@Published var marketData: MarketDataModel? = nil
	var marketSubscription: AnyCancellable?
	
	init() {
		getMarketData()
	}
	
	func getMarketData() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
		marketSubscription = NetworkingManager.download(url: url)
			.decode(type: GLobalData.self, decoder: JSONDecoder().snakeToCamelCaseDecoder)
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
				self?.marketData = returnedGlobalData.data
				self?.marketSubscription?.cancel()
			}
		)
	}
}
