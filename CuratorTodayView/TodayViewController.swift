import UIKit
import NotificationCenter

let ID = "Cell"

class TodayViewController: UIViewController,
	UICollectionViewDataSource,
	UICollectionViewDelegate {

	var results:Array<AnyObject>?
	@IBOutlet var collectionView: UICollectionView?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.clearColor()
		self.collectionView!.backgroundColor = UIColor.clearColor()
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumLineSpacing = 10.0
		flowLayout.itemSize = CGSizeMake(60, 60)
		self.collectionView!.collectionViewLayout = flowLayout
		self.collectionView!.registerClass(TodayCollectionCell.self, forCellWithReuseIdentifier: ID)
		self.widgetPerformUpdateWithCompletionHandler({result in})
		self.preferredContentSize = CGSizeMake(320, 480)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
		if let r = results {
			return r.count
		}
		return 0
	}

	func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
		var cell: TodayCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as TodayCollectionCell
		var item: Dictionary<String, String> = self.results![indexPath.row] as Dictionary<String, String>
		cell.name = item["name"]!
		cell.URL = NSURL(string: item["image"])
		return cell
	}

	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		if let a = self.results {
			completionHandler(NCUpdateResult.NoData)
		}
		else {
			CuratorAPI.sharedAPI().fetchStream({
				response, error in
				if let e = error {
					completionHandler(NCUpdateResult.Failed)
					return
				}
				completionHandler(NCUpdateResult.NewData)

				var results: Array<AnyObject> = (response as NSDictionary).objectForKey("results") as Array<AnyObject>
				self.results = results
				self.collectionView!.reloadData()
//				self.preferredContentSize = self.collectionView!.contentSize
				})
		}
	}
}
