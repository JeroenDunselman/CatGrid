//
//  TextVC.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class TextVC: UIViewController, ActivityView {
  @IBOutlet weak var webView: UIWebView!

  @IBOutlet weak var activityView: UIActivityIndicatorView!
  @IBAction func actionDone(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.activityView.startAnimating()
    self.webView.isHidden = true
    self.webView.showLoremScript(vc: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func presentView() {
    activityView.stopAnimating()
    webView.isHidden = false
  }
}

protocol ActivityView : NSObjectProtocol {
  func presentView()
}

extension UIWebView {
  func showLoremScript(vc: ActivityView) {
    let loremUrl:String = "http://loripsum.net/api/10/short/headers"
    
    // Create URL
    let url = NSURL(string: loremUrl)
    let request = NSMutableURLRequest(url:url! as URL);
    request.httpMethod = "GET"
    
    // Excute HTTP
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      guard let data = data, error == nil else { return }
      
      // Load response string to self
      let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
      
      DispatchQueue.main.async {
        self.loadHTMLString(responseString! as String, baseURL: nil)
        vc.presentView()
      }
    }
    task.resume()
  }
}


