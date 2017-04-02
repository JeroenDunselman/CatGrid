//
//  MessengerVC.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class MessengerVC: UIViewController, UIScrollViewDelegate, MessageView, UITableViewDataSource, UITableViewDelegate  {
  
  @IBOutlet weak var activityIndicatorBottom: UIActivityIndicatorView!
  @IBOutlet weak var activityIndicatorTop: UIActivityIndicatorView!
  @IBOutlet var scrollView: UIScrollView! //niu
  @IBOutlet weak var tableView: UITableView!

  var service:GifService?
  func startLoading(msg: String){
    print("MessengerVC.startLoading msg\(msg)")
  }
  func finishLoading(){}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView!.dataSource = self
    self.tableView!.delegate = self
    self.tableView!.estimatedRowHeight = 120
    self.tableView!.rowHeight = UITableViewAutomaticDimension
    
    service = GifService(vc: self)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
//}
//
//extension MessengerVC: UITableViewDataSource, UITableViewDelegate  {
//  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CatTVCell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    //    let service: String = (self.service?.rowInfo(row: indexPath.row))!
    let service: UIImage? = (self.service?.rowInfo(row: indexPath.row))
    //    cell.textLabel?.text = (" \(service)")
//    cell.imageView?.image = service
    if !(service == nil) {
      cell.catView.image = service!
//      cell.imageView?.image = service!

    } else {
//      cell.imageView?.image = self.defaultImgWhileLoading
      cell.catView.image = self.defaultImgWhileLoading
    }
    cell.textLabel?.text = String(indexPath.row)
    return cell as CatTVCell
  }
  
  let scrollDistanceTriggersReload: CGFloat = 100
  var refreshDirectionIsTopToBottom: Bool = true
  var scrollDirectionIsTopToBottom: Bool = true
  private var lastContentOffset: CGFloat = 0
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    
    let triggerForBottomScroll:Bool = distanceFromBottom < height - scrollDistanceTriggersReload
    let triggerForTopScroll:Bool =  scrollView.contentOffset.y < -(scrollDistanceTriggersReload)
    
    if (triggerForBottomScroll || triggerForTopScroll) {
      refreshDirectionIsTopToBottom = triggerForTopScroll
      self.service?.initData()
    }
    
    scrollDirectionIsTopToBottom = (self.lastContentOffset <= scrollView.contentOffset.y)
    self.lastContentOffset = scrollView.contentOffset.y
  }
}
