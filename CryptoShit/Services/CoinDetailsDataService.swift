import Foundation

import Combine

class CoinDetailsDataService {
	
	@Published var coinDetailsData: CoinDetailsModel? = nil
	
	var coinDetailsSubscription: AnyCancellable?
	let coin: CoinModel
	
	init(coin: CoinModel) {
		self.coin = coin
		getCoinDetails()
	}
	
	private func getCoinDetails() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false%tickers=false&market_data=false&community_data=false&sparkline=false") else { return }
		coinDetailsSubscription = NetworkingManager.download(url: url)
			.decode(type: CoinDetailsModel.self, decoder: JSONDecoder().snakeToCamelCaseDecoder)
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetailsData in
				self?.coinDetailsData = returnedCoinDetailsData
				self?.coinDetailsSubscription?.cancel()
			})
	}
}
