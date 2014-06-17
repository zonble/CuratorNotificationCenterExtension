import Foundation

let CuratorAPIKEY = ""
let CuratorAPIBaseURLString = "http://curator.im/api/"

typealias CuratorAPICallback = (AnyObject?, NSError?)->()

class CuratorAPI {

	class func sharedAPI() -> CuratorAPI {
		struct private {
			static let sharedAPI = CuratorAPI()
		}
		assert(CuratorAPIKEY != "", "You must have your API key!")
		return private.sharedAPI
	}

	var currentDataTask :NSURLSessionDataTask?
	func fetchStream(callback:CuratorAPICallback) {
		currentDataTask?.cancel()

		var URLString = "\(CuratorAPIBaseURLString)stream/?token=\(CuratorAPIKEY)"
		var newTask = NSURLSession.sharedSession().dataTaskWithHTTPGetRequest(NSURL(string: URLString), completionHandler: {data, response, error in
			self.currentDataTask = nil
			if let e = error {
				dispatch_async(dispatch_get_main_queue(), {
					callback(nil, e as? NSError)
					})
				return
			}
			if let d = data {
				var JSONError: NSError?
				var JSONObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(d, options: .fromMask(0), error: &JSONError)
				if let e = JSONError {
					dispatch_async(dispatch_get_main_queue(), {
						callback(nil, e as? NSError)
						})
					return
				}
				if let jobj: AnyObject = JSONObject {
					dispatch_async(dispatch_get_main_queue(), {
						callback(jobj, nil)
						})
				}
			}
			}
		)
		self.currentDataTask = newTask
		newTask.resume()
	}
}
