//
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class CatGifVC: UIViewController,  MessageView {
  
  @IBOutlet weak var activityIndicatorBottom: UIActivityIndicatorView!
  @IBOutlet weak var activityIndicatorTop: UIActivityIndicatorView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var tableView: UITableView!
  
  let scrollDistanceTriggersReload: CGFloat = 100
  var lastContentOffset: CGFloat = 0
  
  var service: GifService?
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    service = GifService(vc: self)

    //http://stackoverflow.com/questions/30824076/incorrect-uitableviewcell-height-uiimageview
    self.tableView!.estimatedRowHeight = estimatedRowHeightForPreferredBufferSize()
    self.tableView!.rowHeight = UITableViewAutomaticDimension
  
  }
  
  //preferredBufferSize = 12
  //number of cells being prepared by tableview is relative to estimated height (inversely proportional)
  func estimatedRowHeightForPreferredBufferSize() -> CGFloat {
    let heightTested: CGFloat = 120
    return heightTested
  }
  
  func refresh() {
    self.service?.refresh()
    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension CatGifVC: UITableViewDataSource, UITableViewDelegate  {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: CatTVCell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
    var resultImage: UIImage
    if let availableImage: UIImage = self.service?.findImageFor(row: indexPath.row) {
      resultImage = availableImage
    } else {
      //temp img
      resultImage = self.defaultImgWhileLoading!
      
      //specialRequest will update cell to show the image once it becomes available
      self.service?.specialRequest(row: indexPath.row, imageView: cell.catView)
    }
    
    cell.catView.image = resultImage
    cell.textLabel?.text = String(indexPath.row)
    return cell as CatTVCell
  }
}

extension CatGifVC: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    
    let triggerForBottomScroll:Bool = distanceFromBottom < height - scrollDistanceTriggersReload
    let triggerForTopScroll:Bool =  scrollView.contentOffset.y < -(scrollDistanceTriggersReload)
    
    if (triggerForBottomScroll || triggerForTopScroll) {
      self.refresh()
    }
    
    self.lastContentOffset = scrollView.contentOffset.y
  }
}

extension CatGifVC {
  
  func startLoadingMessageView(msg: String) {
    self.activityIndicatorTop.startAnimating()
    self.activityIndicatorBottom.startAnimating()
    self.tableView.reloadData()
//    print("CatGifVC.GifService.startLoading msg \(msg)")
  }
  
  func finishLoadingMessageView() {
    self.activityIndicatorTop.stopAnimating()
    self.activityIndicatorBottom.stopAnimating()
  }

}


