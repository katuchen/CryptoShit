import Foundation

/*  Coin Gecko API INFO
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 */

struct CoinModel: Identifiable, Codable {
	let id, symbol, name: String
	let image: String
	let currentPrice: Double
	let marketCap, marketCapRank, fullyDilutedValuation: Double?
	let totalVolume, high24H, low24H: Double?
	let priceChange24H, priceChangePercentage24H: Double?
	let marketCapChange24H: Double?
	let marketCapChangePercentage24H: Double?
	let circulatingSupply, totalSupply, maxSupply, ath: Double?
	let athChangePercentage: Double?
	let athDate: String?
	let atl, atlChangePercentage: Double?
	let atlDate: String?
	let lastUpdated: String?
	let sparklineIn7D: SparklineIn7D?
	let priceChangePercentage24HInCurrency: Double?
	let currentHoldings: Double?
	
	func updateHoldings(amount: Double) -> CoinModel {
		return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
	}
	
	var currentHoldingValue: Double {
		return (currentHoldings ?? 0) * currentPrice
	}
	
	var rank: Int {
		return Int(marketCapRank ?? 0)
	}
}

struct SparklineIn7D: Codable {
	let price: [Double]?
}
