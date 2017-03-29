//
//  ViewController.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
  
  func startLoading() {}
  func finishLoading() {}
  @IBOutlet var tableView : UITableView?
  var catPresenter:CatService?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView!.estimatedRowHeight = 160
    tableView!.rowHeight = UITableViewAutomaticDimension
    
    catPresenter = CatService(vc: self)//self.tv
    catPresenter?.getCats()
  }
  
  //TableviewDelegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return catPresenter!.catItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> CatTVCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTVCell
    
    let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
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
