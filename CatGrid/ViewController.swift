//
//  ViewController.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, CatView {
  
  //
  @IBOutlet var tableView: UITableView?
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var activityIndicatorBottom: UIActivityIndicatorView!
  @IBOutlet weak var activityIndicatorTop: UIActivityIndicatorView!
  let scrollDistanceTriggersReload: CGFloat = 100
  var refreshDirectionIsTopToBottom: Bool = true
  var scrollDirectionIsTopToBottom: Bool = true
  
  let limitRangeToMemSize: Int = 20
  var catPresenter:CatService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView!.estimatedRowHeight = 260
    tableView!.rowHeight = UITableViewAutomaticDimension
    
    catPresenter = CatService(vc: self)//self.tv
    catPresenter?.getCats()
  }
  
  private var lastContentOffset: CGFloat = 0
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    
    let triggerForBottomScroll:Bool = distanceFromBottom < height - scrollDistanceTriggersReload
    let triggerForTopScroll:Bool =  scrollView.contentOffset.y < -(scrollDistanceTriggersReload)
    
    if (triggerForBottomScroll || triggerForTopScroll) {
      refreshDirectionIsTopToBottom = triggerForTopScroll
      initData()
    }
    
    scrollDirectionIsTopToBottom = (self.lastContentOffset <= scrollView.contentOffset.y)
    self.lastContentOffset = scrollView.contentOffset.y
  }
  
  func initData() {
    numCellsOnMain = 0
    catPresenter?.getCats()
  }
  
  func startLoading(){
    self.activityIndicatorTop.startAnimating()
    self.activityIndicatorBottom.startAnimating()
  }
  func finishLoading() {
    self.activityIndicatorTop.stopAnimating()
    self.activityIndicatorBottom.stopAnimating()
  }
  
  //TableviewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 100 //catPresenter!.catItems.count
  }
  
  let limitNumCellsOnMain: Int = 10
  var numCellsOnMain:Int = 0 //todo init @refresh
  
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  
  func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> CatTVCell
  {
    let row:Int = indexPath.row
    print("row: \(row)")
    let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
//    cell.catView.image = nil
    
    if let image = catPresenter!.didSelect(row: row, direction: scrollDirectionIsTopToBottom) as UIImage! {
      cell.catView.image = image
      return cell as CatTVCell
    }
    
    //main
    if (cell.catView.image == nil) {
      cell.catView.image = defaultImgWhileLoading
//      if numCellsOnMain < limitNumCellsOnMain {
        //creer loaditem met urlBase.removefirst en catview
        catPresenter!.didSelect(row: row, direction: scrollDirectionIsTopToBottom, view: cell.catView)
      
      numCellsOnMain += 1
        
//      }
    }
    
    return cell as CatTVCell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}



//0.0
//    let item:LoadItem = catPresenter!.catItems[row]

//    if (item.urlLocal != nil) { //(item.image != nil) {
//      cell.catView.image = item.image
//    if (item.stored) {
//      //DispatchQueue.global(qos: .userInitiated).async {
//      //if let image = NSKeyedUnarchiver.unarchiveObject(withFile: (item.urlLocal?.absoluteString)!) as? UIImage {
//      //          DispatchQueue.main.async {
//      cell.catView.image = item.image
//      //          }
//      //        }
//      //}
//    } else {
//      cell.catView.image = defaultImgWhileLoading






//    //trigger dl next batch
//    //    if self.scrollView.dir
//    let batchSize:Int = 20
//    var rowPrepare:Int = 0
//
//    if refreshDirectionIsTopToBottom {
//      rowPrepare = max(row + batchSize, catPresenter!.catItems.count - 1)
//    } else {
//      rowPrepare = max(row - batchSize, 0)
//    }
//
//    if row + 20 < catPresenter!.catItems.count {
//      if let nextBatchItem = catPresenter!.catItems[rowPrepare] as LoadItem! {
//        if (!nextBatchItem.stored) {
//          DispatchQueue.global(qos: .userInitiated).async {
//            nextBatchItem.downloadImage(url: nextBatchItem.urlRemote)
//          }
//        }
//      }
//    }

