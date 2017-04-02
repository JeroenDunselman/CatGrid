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
  
  var service:GifService?
  func startLoading(msg: String) {
    self.activityIndicatorTop.startAnimating()
    self.activityIndicatorBottom.startAnimating()
    print("GifService.startLoading msg \(msg)")
  }
  func finishLoading() {
    self.activityIndicatorTop.stopAnimating()
    self.activityIndicatorBottom.stopAnimating()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView!.dataSource = self
    self.tableView!.delegate = self
    
    self.tableView!.estimatedRowHeight = 120
    //    http://stackoverflow.com/questions/30824076/incorrect-uitableviewcell-height-uiimageview
    self.tableView!.rowHeight = UITableViewAutomaticDimension
    
    service = GifService(vc: self)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  
  let scrollDistanceTriggersReload: CGFloat = 100
//  var refreshDirectionIsTopToBottom: Bool = true
  var scrollDirectionIsTopToBottom: Bool = true
  var lastContentOffset: CGFloat = 0
}

extension CatGifVC: UITableViewDataSource, UITableViewDelegate  {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CatTVCell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
    let service: UIImage? = (self.service?.rowInfo(row: indexPath.row))
    
    if !(service == nil) {
      cell.catView.image = service!
    } else {
      
      self.service?.specialRequest(row: indexPath.row, imageView: cell.catView)
      cell.catView.image = self.defaultImgWhileLoading
    }
    
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
//      refreshDirectionIsTopToBottom = triggerForTopScroll
      self.service?.getCats()
    }
    
    self.scrollDirectionIsTopToBottom = (self.lastContentOffset <= scrollView.contentOffset.y)
    self.lastContentOffset = scrollView.contentOffset.y
  }
}
