import Foundation
import UIKit

class CuratorImageFetcher {
	class func sharedFetcher() -> CuratorImageFetcher {
		struct private {
			static let sharedFetcher = CuratorImageFetcher()
		}
		return private.sharedFetcher
	}

	var operationQueue:NSOperationQueue?
	var URLSession:NSURLSession?

	init () {
		self.operationQueue = NSOperationQueue()
		let conf: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
		self.URLSession = NSURLSession(configuration: conf, delegate: nil, delegateQueue: nil)
	}

	func requestImage(#URL:NSURL, callback:(UIImage?, NSError?)->()) {
		var request = NSURLRequest(URL: URL)
		var data:NSData? = self.URLSession!.configuration.URLCache.cachedResponseForRequest(request)?.data
		if let d = data {
			var image:UIImage? = UIImage(data: d)
			if let i = image {
				callback(i, nil)
			}
			return
		}
		var task = self.URLSession!.dataTaskWithRequest(request, completionHandler: {data, response, error in
			if let e = error {
				dispatch_async(dispatch_get_main_queue(), {
					callback(nil, e)
					})
				return
			}
			var image:UIImage? = UIImage(data: data)
			if let i = image {
				dispatch_async(dispatch_get_main_queue(), {
					callback(i, nil)
				})
			}
			})
		task.resume()
	}
}