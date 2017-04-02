//
//  GifRequest.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//
import Foundation
import UIKit

class GifRequest : NSObject {
  let gifLocation:String
  var image:UIImage? // = nil
  var urlRemote: URL!
  var finishedLoading: Bool = false
  var assignedToRow: Int?
  
  init(url: String) {
    gifLocation = url
    urlRemote = URL(string: gifLocation)
  }
  
  func downloadImage() {
    print("Download \(self.gifLocation)")
    getDataFromUrl(url: self.urlRemote) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.async() { () -> Void in
        self.image = UIImage.gifImageWithData(data)
      }
      self.finishedLoading = true
    }
  }
  
  func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
}
