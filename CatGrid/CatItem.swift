//
//  CatItem.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit
var counter: Int = 0
class Item : NSObject {
  
  var imageUrl:String!
  var image:UIImage? = nil
  var imgURL: URL!
  
  init(info: NSDictionary)
  {
    super.init()
    imageUrl = self.stringCheck(string:(info["url"] as? String)!)
    imgURL = URL(string: imageUrl)
    downloadImage(url: imgURL)
  }
  
  func downloadImage(url: URL) {
//    print("Download Started")
    getDataFromUrl(url: url) { (data, response, error)  in
    guard let data = data, error == nil else { return }
//      print("Download Finished")
      self.count()
      DispatchQueue.main.async() { () -> Void in
        self.image = UIImage(data: data)
      }
    }
  }
  
  func downloadImage(url: URL, imageVw:UIImageView) {
//    print("Download Started")
    getDataFromUrl(url: url) { (data, response, error)  in
      guard let data = data, error == nil else { return }

//      self.count()
      DispatchQueue.main.async() { () -> Void in
        imageVw.image = UIImage(data: data)
      }
    }
  }
  
  func count() {
    counter += 1
    print("counter: \(counter)")
  }
  
  func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
  func stringCheck(string: String) -> (String) {
    return string.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
  }
}
