import UIKit

class TodayCollectionCell: UICollectionViewCell {
	var name: NSString = ""
	var URL: NSURL? {
	willSet {
		self.image = nil
		self.setNeedsDisplay()
	}
	didSet {
		if self.URL == nil {
			return
		}
		CuratorImageFetcher.sharedFetcher().requestImage(URL: self.URL!, callback:
			{inImage, error in
				if let i = inImage {
					self.image = i
					self.setNeedsDisplay()
				}
			})
	}
	}
	var image: UIImage?

	override func drawRect(rect: CGRect) {
		if let i = self.image {
			i.drawInRect(self.bounds)
		}
	}
}
