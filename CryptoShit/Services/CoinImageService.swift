import Foundation
import SwiftUI
import Combine

class CoinImageService {
	
	@Published var image: UIImage? = nil
	
	var imageSubscription: AnyCancellable?
	private let coin: CoinModel
	private let fileManeger = LocalFileManager.instance
	private let folderName = "coin_images"
	private let imageName: String
	
	init(coin: CoinModel) {
		self.coin = coin
		self.imageName = coin.id
		getCoinImage()
	}
	
	private func getCoinImage() {
		if let savedImage = fileManeger.getImage(imageName: imageName, folderName: folderName) {
			image = savedImage
			print("Retrieved image from File Manager")
		} else {
			downloadCoinImage()
			print("Downloading image now!")
		}
	}
	
	private func downloadCoinImage() {
		guard let url = URL(string: coin.image) else { return }
		imageSubscription = NetworkingManager.download(url: url)
			.tryMap({ data -> UIImage? in
				return UIImage(data: data)
			})
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
				guard let downloadedImage = returnedImage else { return }
				self?.image = downloadedImage
				self?.imageSubscription?.cancel()
				self?.fileManeger.saveImage(image: downloadedImage, imageName: self?.imageName ?? "", folderName: self?.folderName ?? "")
			}
		)
	}
}
