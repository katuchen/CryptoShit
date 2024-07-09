import Foundation


extension Double {
	
	/// Конвертирует Double в валюту с 2-6 знаками после запятой
	/// Например: 1234.56 -> $1,234.56
	private var currencyFormatter: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		formatter.locale = Locale(identifier: "en_US")
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 6
		return formatter
	}
	
	/// Конвертирует Double в строку с валютой с 2-6 знаками после запятой
	/// Например: 1234.5612121 -> "$1,234.56"
	func asCurrency() -> String {
		let number = NSNumber(value: self)
		return currencyFormatter.string(from: number) ?? "$0.00"
	}
	
	/// Конвертирует Double в валюту с 2 знаками после запятой
	/// Например: 1234.56 -> $1,234.56
	private var currencyFormatterShort: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		formatter.locale = Locale(identifier: "en_US")
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}
	
	/// Конвертирует Double в строку с валютой с 2 знаками после запятой
	/// Например: 1234.561212 -> "$1,234.56"
	func asCurrencyShort() -> String {
		let number = NSNumber(value: self)
		return currencyFormatter.string(from: number) ?? "$0.00"
	}
	
	/// Конвертирует Double в строку с 2 знаками после запятой
	/// Например: 1.2345 -> "1.23"
	func asNumberString() -> String {
		return String(format: "%.2f", self)
	}
	
	/// Добавляет % к строке
	/// Например: "1.23" -> "1.23%"
	func asPercent() -> String {
		return asNumberString() + "%"
	}
	
	/// Конвертирует Double в String с аббривеатурой числа (K, M, Bn, Tr)
	/// ```
	/// 12 to 12.00
	/// 1234 to 1.23K
	/// 123456 to 123.45K
	/// 12345678 to 12.34M
	/// 1234567890 to 1.23Bn
	/// 12345678901234 to 12.34Tr
	/// ```
	func formattedWithAbbreviations() -> String {
		let num = abs(Double(self))
		let sign = (self < 0) ? "-" : ""
		
		switch num {
			case 1_000_000_000_000...:
				let formatted = num / 1_000_000_000_000
				let stringFormatted = formatted.asNumberString()
				return "$\(sign)\(stringFormatted)Tr"
			case 1_000_000_000...:
				let formatted = num / 1_000_000_000
				let stringFormatted = formatted.asNumberString()
				return "$\(sign)\(stringFormatted)Bn"
			case 1_000_000...:
				let formatted = num / 1_000_000
				let stringFormatted = formatted.asNumberString()
				return "$\(sign)\(stringFormatted)M"
			case 1_000...:
				let formatted = num / 1_000
				let stringFormatted = formatted.asNumberString()
				return "$\(sign)\(stringFormatted)K"
			case 0...:
				return self.asNumberString()
				
			default:
				return "\(sign)\(self)"
		}
	}
}
