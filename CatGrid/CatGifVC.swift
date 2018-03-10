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
  
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  
  let scrollDistanceTriggersReload: CGFloat = 100
  //  var refreshDirectionIsTopToBottom: Bool = true
  var scrollDirectionIsTopToBottom: Bool = true
  var lastContentOffset: CGFloat = 0
  
  var service: GifService?
//  let timeOutRefresh: Double = 5
//  var serviceAvailabilityTimer:Timer?
//  var availability:Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    service = GifService(vc: self)
    
    //    self.tableView!.dataSource = self
    //    self.tableView!.delegate = self

    //http://stackoverflow.com/questions/30824076/incorrect-uitableviewcell-height-uiimageview
    self.tableView!.estimatedRowHeight = 200
    self.tableView!.rowHeight = UITableViewAutomaticDimension
  
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
      resultImage = self.defaultImgWhileLoading!
      //specialRequest will show the image once it's available
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
//      refreshDirectionIsTopToBottom = triggerForTopScroll
      self.refresh()
    }
    
    self.scrollDirectionIsTopToBottom = (self.lastContentOffset <= scrollView.contentOffset.y)
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

//  func tryRefresh() {
//
////    if availability {
////      serviceAvailabilityTimer = Timer.scheduledTimer(timeInterval: timeOutRefresh, target:self, selector: #selector(self.releaseService), userInfo: nil, repeats: true)
////      availability = false
//
//      self.service?.refreshCats()
//      self.tableView.reloadData()
////    } //else {      print("Service availability timed out by scroll")     }
//
//  }
//
////  func releaseService() {
////    availability = true
////    serviceAvailabilityTimer?.invalidate()
////    //    client?.finishLoading(msg: "service released")
////  }


/*
 if let availableImage: UIImage = self.service?.findImageFor(row: indexPath.row) {
 cell.catView.image = availableImage
 print("available gif for row \(indexPath.row)")
 } else {
 self.service?.makeRequest(num: 5)
 cell.catView.image = self.defaultImgWhileLoading
 if let requested: GifRequest = self.service?.gifRequests.filter({($0.assignedToRow == indexPath.row)}).first {
 
 print("unfinished specialRequest for row \(indexPath.row)")
 //        cell.catView.image = requested.image
 } else {
 self.service?.specialRequest(row: indexPath.row, imageView: cell.catView)
 print("new specialRequest for row \(indexPath.row)")
 }
 }
 */

//    if let requested: GifRequest = self.service?.gifRequests.filter({($0.assignedToRow == indexPath.row)}).first {
//      print("existing request for row \(indexPath.row)")
//      let gif: UIImage? = requested.image //(self.service?.rowInfo(row: indexPath.row))
//      if !(gif == nil) {
//        cell.catView.image = gif!
//        print("available gif for row \(indexPath.row)")
//      } else {
//        print("unfinished specialRequest for row \(indexPath.row)")
//      }
//    } else {
//      //check if any available unassigned
//            self.service?.makeRequest(num: 15)
//      self.service?.specialRequest(row: indexPath.row, imageView: cell.catView)
//      cell.catView.image = self.defaultImgWhileLoading
//      print("specialRequest for row \(indexPath.row)")
////      if indexPath.row == 0 {print("")}
//    }

//    let image: UIImage? = (self.service?.rowInfo(row: indexPath.row))
//
//    if !(image == nil) {
//      cell.catView.image = image!
//      print("existing service for row \(indexPath.row)")
//    } else {
//      self.service?.specialRequest(row: indexPath.row, imageView: cell.catView)
////      self.service?.makeRequest(num: <#T##Int#>)
//      cell.catView.image = self.defaultImgWhileLoading
//      print("specialRequest for row \(indexPath.row)")
//      if indexPath.row == 0 {
//        print("")
//
//      }
//    }
