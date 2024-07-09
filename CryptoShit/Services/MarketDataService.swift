import Foundation
import Combine

class MarketDataService {
	
	@Published var marketData: MarketDataModel? = nil
	var marketSubscription: AnyCancellable?
	// Декодер автоматически кодирует данные в Camel Case из Snake Case
	var trueDecoder : JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
	
	init() {
		getMarketData()
	}
	
	private func getMarketData() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
		marketSubscription = NetworkingManager.download(url: url)
			.decode(type: GLobalData.self, decoder: trueDecoder)
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
				self?.marketData = returnedGlobalData.data
				self?.marketSubscription?.cancel()
			}
		)
	}
}
