//
//  ViewController.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UIScrollViewDelegate {
  
//  func startLoading() {}
//  func finishLoading() {}
//  
  @IBOutlet var tableView : UITableView?
  @IBOutlet var scrollView: UIScrollView!
  
  var catPresenter:CatService?
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView!.estimatedRowHeight = 160
    tableView!.rowHeight = UITableViewAutomaticDimension
    
    catPresenter = CatService(vc: self)//self.tv
    catPresenter?.getCats()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let backgroundMargin:CGFloat = 100
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    if distanceFromBottom < height - backgroundMargin {
      print(" you reached end of the table")
      catPresenter?.getCats()
    }
    if scrollView.contentOffset.y < -(backgroundMargin) {
      print(" you reached the top of the table")
      catPresenter?.getCats()
    }
  }
  
  //TableviewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return catPresenter!.catItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> CatTVCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
    cell.catView.image = defaultImgWhileLoading
    
    let item:Item = catPresenter!.catItems[indexPath.row]
    if (item.image != nil) {
      cell.catView.image = item.image
    } else {
      item.downloadImage(url: item.imgURL, imageVw:cell.catView!)
    }
    
    return cell as CatTVCell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
