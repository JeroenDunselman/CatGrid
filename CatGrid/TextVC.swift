//
//  TextVC.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class TextVC: UIViewController {
  @IBOutlet weak var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.webView.showLoremScript()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension UIWebView {
  
  func showLoremScript() {
    let loremUrl:String = "http://loripsum.net/api/10/short/headers"
    
    // Create URL
    let url = NSURL(string: loremUrl)
    let request = NSMutableURLRequest(url:url! as URL);
    request.httpMethod = "GET"
    
    // Excute HTTP
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
      data, response, error in
      if error != nil
      {
        print("error=\(error)")
        return
      }
      
      // Load response string to self
      let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
      self.loadHTMLString(responseString as! String, baseURL: nil)
    }
    task.resume()
  }
  
}



//    let scriptUrl = loremUrl //"http://swiftdeveloperblog.com/my-http-get-example-script/"
//    // Add one parameter
//    let urlWithParams = loremUrl //scriptUrl + "?userName=\(userNameValue!)"
//    // Create NSURL Ibject



//  let strY:String = "<!DOCTYPE html><html><head><title>Hello Lorem Ipsump</title><link rel=\"stylesheet\" href=\"myCSS.css\" type=\"text/css\"></head><body></body>"
//    let myURL:String = strX
//      Bundle.main.url(forResource: "myHtml",withExtension: "html")

//    var txtURL: URL!
//    txtURL = URL(string: strX)
//    let txtURL:URL = URL(string: strLoremUrl)!
//    let requestObj = NSURLRequest(url:txtURL)
//    var readLorem:UIWebView = UIWebView()
//    readLorem.loadRequest(requestObj as URLRequest)
////    let strResult:String = readLorem.str
//    let doc = readLorem.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")




//      // Convert server json response to NSDictionary
//      do {
//        if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//
//          // Print out dictionary
//          print(convertedJsonIntoDict)
//
//          // Get value by key
//          let firstNameValue = convertedJsonIntoDict["userName"] as? String
//          print(firstNameValue!)
//
//        }
//      } catch let error as NSError {
//        print(error.localizedDescription)
//      }
//  var strLorem:String = ""
//  func networkFunction(query: String, completion: @escaping (_ success: Bool) -> Void) {
//    var url = strLoremUrl //"http://notrealurl.com/etix.asp?t=scanticket&sid=100000&tid=" + query
//
//    let task = URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (responseData, response, error) -> Void in
//      if error == nil {
//        let feedback = NSString(data: responseData!, encoding: String.Encoding.utf8.rawValue)
//        strLorem = responseData
//        completion(feedback == "valid")
//      } else {
//        print(error)
//        completion(false)
//      }
//    })
//  }
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
