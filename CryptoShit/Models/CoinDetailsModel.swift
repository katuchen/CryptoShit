import Foundation

struct CoinDetailsModel: Codable {
	let id, symbol, name: String
	let blockTimeInMinutes: Int?
	let hashingAlgorithm: String?
	let categories: [String]?
	let description: Description?
}

struct Description: Codable {
	let en: String
}
