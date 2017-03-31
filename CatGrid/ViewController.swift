//
//  ViewController.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UIScrollViewDelegate, CatView {
  
  //
  @IBOutlet var tableView : UITableView?
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet weak var activityIndicatorBottom: UIActivityIndicatorView!
  @IBOutlet weak var activityIndicatorTop: UIActivityIndicatorView!
  
  let defaultImgWhileLoading = UIImage(named:"thin-1474_cat_pet-128")
  let triggerLoadScrollDistance:CGFloat = 100
  
  var catPresenter:CatService?
  
  @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
//    if let playerDetailsViewController = segue.sourceViewController as? PlayerDetailsViewController {
//      
//      //add the new player to the players array
//      if let player = playerDetailsViewController.player {
//        players.append(player)
//        
//        //update the tableView
//        let indexPath = NSIndexPath(forRow: players.count-1, inSection: 0)
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//      }
//    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView!.estimatedRowHeight = 160
    tableView!.rowHeight = UITableViewAutomaticDimension
    
    catPresenter = CatService(vc: self)//self.tv
    catPresenter?.getCats()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let height = scrollView.frame.size.height
    let contentYoffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    
    let refreshForBottomScroll:Bool = distanceFromBottom < height - triggerLoadScrollDistance
    let refreshForTopScroll:Bool =  scrollView.contentOffset.y < -(triggerLoadScrollDistance)
    
    if (refreshForBottomScroll || refreshForTopScroll) {
      getCats()
    }
  }
  
  func getCats() {
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
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print("hel")
//  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("hel")
  }
//  func tableView(_ tableView: UITableView, didSelectRowAt
//    indexPath: IndexPath) {
//    
//    //your code...
////    self.window = UIWindow(frame: UIScreen.main.bounds)
//    let nav1 = UINavigationController()
//    let mainView = TestVC(nibName: "TestVC", bundle: nil) //ViewController = Name of your controller
//    nav1.viewControllers = [mainView]
//    present(nav1, animated: true, completion: {print("completed")})
////    self.window!.rootViewController = nav1
////    self.window?.makeKeyAndVisible()
//    
//  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
