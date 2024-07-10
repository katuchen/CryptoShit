import Foundation
import SwiftUI

class LocalFileManager {
	static let instance = LocalFileManager()
	private init() { }
	
	func saveImage(image: UIImage, imageName: String, folderName: String) {
		createFolderIfNeeded(folderName: folderName)
		
		guard
			let data = image.pngData(),
			let url = getImageURL(imageName: imageName, folderName: folderName)
		else { return }
		
		do {
			try data.write(to: url)
		} catch let error {
			print("Error saving image \(imageName) to \(url): \(error)")
		}
	}
	
	func getImage(imageName: String, folderName: String) -> UIImage? {
		guard
			let url = getImageURL(imageName: imageName, folderName: folderName),
			FileManager.default.fileExists(atPath: url.path) else { return nil }
		return UIImage(contentsOfFile: url.path)
	}
	
	private func createFolderIfNeeded(folderName: String) {
		guard
			let url = getFolderURL(folderName: folderName) else { return }
		
		if !FileManager.default.fileExists(atPath: url.path) {
			do {
				try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
			} catch let error {
				print("Error creating directory \(folderName): \(error)")
			}
		}
	}
	
	private func getFolderURL(folderName: String) -> URL? {
		guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
		return url.appendingPathComponent(folderName)
	}
	
	private func getImageURL(imageName: String, folderName: String) -> URL? {
		guard let folderURL = getFolderURL(folderName: folderName) else { return nil }
		return folderURL.appendingPathComponent(imageName, conformingTo: .png)
	}
}
