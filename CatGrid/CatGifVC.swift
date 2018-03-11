//
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class CatGifVC: UIViewController {
  
  @IBOutlet weak var activityIndicatorBottom: UIActivityIndicatorView!
  @IBOutlet weak var activityIndicatorTop: UIActivityIndicatorView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var tableView: UITableView!
  
  var service: GifService?
  
  let initialRequestTime: Double = 1.5
  let defaultImage = UIImage(named:"thin-1474_cat_pet-128")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicatorTop.startAnimating()
    activityIndicatorBottom.startAnimating()
    service = GifService(viewcontroller: self)
    
    tableView!.estimatedRowHeight = 120
    tableView!.rowHeight = UITableViewAutomaticDimension
    
    //  Allow initial request time.
    initializeTableView()
  }
  
  var initTimer:Timer?
  func initializeTableView() {
    
    //    Showing initial default rowheights is prevented by allowing initialRequestTime.
    tableView.isHidden = true
    
    initTimer = Timer.scheduledTimer(timeInterval: initialRequestTime, target:self, selector: #selector(reloadAfterInitialRequestTime), userInfo: nil, repeats: true)
  }
  
  @objc func reloadAfterInitialRequestTime() {
    initTimer?.invalidate()
    
    //    Initial buffer size is ( view.height / defaultImage.height )
    service?.unAssignAvailableImages()
    tableView.reloadData()
    tableView.isHidden = false
  }
  
  //    View fresh batch.
  var timeOutTimer: Timer?
  func refreshTableView() {
    
    let timeOut: Double = 1
    timeOutTimer = Timer.scheduledTimer(timeInterval: timeOut, target:self, selector: #selector(reenableRefresh), userInfo: nil, repeats: true)

    //    Update view.
    service?.refresh()
    tableView.reloadData()

    activityIndicatorBottom.isHidden = true
    activityIndicatorTop.isHidden = true
  }
  
  @objc func reenableRefresh() {
    timeOutTimer?.invalidate()
    timeOutTimer = nil
    
    activityIndicatorBottom.isHidden = false
    activityIndicatorTop.isHidden = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}

extension CatGifVC: UIScrollViewDelegate {

  //    Trigger refresh from pull.
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    //    Prevent repeat refresh for same swipe.
    if !(timeOutTimer == nil) {return}
    
    let pullDistance: CGFloat = 100
    
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    
    let triggeredForBottomScroll:Bool = distanceFromBottom < height - pullDistance
    let triggeredForTopScroll:Bool =  scrollView.contentOffset.y < -(pullDistance)
    
    if (triggeredForBottomScroll || triggeredForTopScroll) {
      refreshTableView()
    }
  }
  
}

extension CatGifVC: UITableViewDataSource, UITableViewDelegate  {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var resultImage: UIImage
    let cell: CatTVCell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
    
    if let availableImage: UIImage = service?.findImageFor(row: indexPath.row) {
      resultImage = availableImage
      
    } else {
      //    Image fails, service buffer was increased.
      resultImage = defaultImage!
      
      //    Imageview of cell will update once requested image becomes available.
      //    But height for row can not update, unless cellForRow is reloaded.
      service?.request(requestRow: indexPath.row, updateView: cell.catView)
    }
    
    cell.catView.image = resultImage
    return cell as CatTVCell
  
  }
}
