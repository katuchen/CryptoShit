import Foundation
import CoreData

class PortfolioDataService {
	private let container: NSPersistentContainer
	private let containerName = "PortfolioContainer"
	private let entityName = "PortfolioEntity"
	
	@Published var savedEntities: [PortfolioEntity] = []
	@Published var totalValue: Double = 0.00
	
	init() {
		container = NSPersistentContainer(name: containerName)
		container.loadPersistentStores { _, error in
			if let error = error {
				print("Error loading core data! \(error)")
			}
			self.getPortfolio()
		}
	}
	
	func updatePortfolio(coin: CoinModel, amount: Double) {
		// Проверка, есть ли монета уже в портфеле
		if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
			if amount > 0 {
				updateAmount(entity: entity, amount: amount)
			} else {
				removeCoin(entity: entity)
			}
		} else {
			add(coin: coin, amount: amount)
		}
	}
	
	private func getPortfolio() {
		let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
		do {
			savedEntities = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching portfolio entities. \(error)")
		}
	}
	
	private func add(coin: CoinModel, amount: Double) {
		let entity = PortfolioEntity(context: container.viewContext)
		entity.coinID = coin.id
		entity.amount = amount
		applyChanges()
	}
	
	private func updateAmount(entity: PortfolioEntity, amount: Double) {
		entity.amount = amount
		applyChanges()
	}
	
	private func removeCoin(entity: PortfolioEntity) {
		container.viewContext.delete(entity)
		applyChanges()
	}
	
	private func saveEverything() {
		do {
			try container.viewContext.save()
		} catch let error {
			print("Error saving to Core Data: \(error)")
		}
	}
	
	private func applyChanges() {
		saveEverything()
		getPortfolio()
	}
}
