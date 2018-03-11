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
  
  var image:UIImage?
  var url: URL!
  var finished: Bool = false
  var assignedToRow: Int?
  
  init(gifLocation: String) {
    url = URL(string: gifLocation)
  }
  
  func downloadImage() {
    getDataFromUrl(url: self.url) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.async() { () -> Void in
        self.image = UIImage.gifImageWithData(data)
        //  Make image available to any row once downloaded.
        self.finished = true
      }
      
    }
  }
  
  func downloadImage(row: Int, imageVw: UIImageView) {
    getDataFromUrl(url: self.url) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      
      //  Claim request for row.
      self.assignedToRow = row
      
      DispatchQueue.main.async() { () -> Void in
        self.image = UIImage.gifImageWithData(data)
        //  Update view once downloaded.
        imageVw.image = self.image
      }

    }
  }
  
  func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
}
