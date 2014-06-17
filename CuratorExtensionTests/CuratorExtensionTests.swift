import XCTest

class CuratorExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

	var results:Array<AnyObject>?

    func test_01Stream() {
		var exp = self.expectationWithDescription("Fetch stream")
		CuratorAPI.sharedAPI().fetchStream({
			response, error in
			var results: Array<AnyObject> = (response as NSDictionary).objectForKey("results") as Array<AnyObject>
			for item: AnyObject in results {
				var d = item as Dictionary<String, AnyObject>

				for key in ["created_at", "height", "id", "image",
							"is_portrait", "name", "thumbnail",
							"thumbnail_height", "thumbnail_width", "url", "width"] {
					XCTAssertNotNil(d[key], "")
				}
			}
			self.results = results
			exp.fulfill()
			})
		self.waitForExpectationsWithTimeout(5, handler: {error in
			if error != nil {
				XCTFail("timeout")
			}})
    }

	func test_02StreamImages() {
		self.test_01Stream()

		if let a:Array = self.results {
			var URLString = a[0]["image"]
			var exp = self.expectationWithDescription("Fetch image")
			CuratorImageFetcher.sharedFetcher().requestImage(URL: NSURL(string: URLString as String),
				callback: {image, error in
					XCTAssertNotNil(image, "")
					exp.fulfill()
				})

			self.waitForExpectationsWithTimeout(5, handler: {error in
				if error != nil {
					XCTFail("timeout")
				}})
		}
		else {
			XCTFail("fail...")
		}
	}

}
