import Foundation

extension JSONDecoder {
	var snakeToCamelCaseDecoder : JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}
