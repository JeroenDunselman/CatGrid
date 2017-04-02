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

class ViewItem : NSObject {
  //
  //var rowNumber: Int
}

class LoadItem : NSObject {
  var finishedLoading: Bool = false
  var urlGif:String!
  var image:UIImage? = nil
  var urlRemote: URL!
  var urlLocal: URL!
  
  var stored: Bool!
  
  init(info: NSDictionary)
  {
    super.init()
    urlGif = self.stringCheck(string:(info["url"] as? String)!)
    urlRemote = URL(string: urlGif)
    stored = false
    
    //    downloadImage(url: urlRemote)
  }
  init(url: String) {
    super.init()
    urlGif = self.stringCheck(string: url)
    urlRemote = URL(string: urlGif)
    stored = false
  }
  
  func clearItem() {
    archiveImage()
    self.image = nil
  }
  
  func prepareItem() {
    if self.finishedLoading {
      self.image = unArchiveImage()
    }
  }
  
  func downloadImage() {
    getDataFromUrl(url: self.urlRemote) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      //      print("Download Finished")
      //      self.count()
      DispatchQueue.main.async() { () -> Void in
        self.image = UIImage.gifImageWithData(data) //imageData!)
      }
      //      self.finishedLoading = true
    }
  }
  

  //todo param url niu
  func downloadImage(url: URL) {
    
//    if (self.stored) {return}
    //    print("Download Started")
    getDataFromUrl(url: self.urlRemote) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      //      print("Download Finished")
      self.count()
      DispatchQueue.main.async() { () -> Void in
      self.image = UIImage.gifImageWithData(data) //imageData!)
      }
      
      //1.0
      self.finishedLoading = true
      
      //0.0
      self.stored = true
      
    }
  }
  
  //0.0
  //todo param url niu
  //  func downloadImage(url: URL, imageVw:UIImageView) {
  ////    print("Download Started")
  //    getDataFromUrl(url: self.urlRemote) { (data, response, error)  in
  //      guard let data = data, error == nil else { return }
  //
  //      self.count()
  //      DispatchQueue.main.async() { () -> Void in
  //        imageVw.image = UIImage(data: data)
  //        self.stored = true
  //      }
  //    }
  //  }
  //1.0
  func downloadImage(imageVw:UIImageView) {
    //1.0
    
    DispatchQueue.global(qos: .userInitiated).async {
      if let imgResult = UIImage.gifImageWithURL(self.urlGif, storeItem: self) {
        print("downloaded from bg")
        //voorgrond
        DispatchQueue.main.async {
          imageVw.image = imgResult
          self.count()
          self.finishedLoading = true
        }
        //          item.image = imgResult
        //          item.stored = true
        //      item.downloadImage(url: item.imgURL, imageVw:cell.catView!)
      }
    }
  }
  
  func count() {
    counter += 1
    print("dl count: \(counter)")
  }
  

  
  func stringCheck(string: String) -> (String) {
    return string.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "{f}", with: "", options: NSString.CompareOptions.literal, range:nil)
  }
  func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
      (data, response, error) in
      completion(data, response, error)
      }.resume()
  }
  
  func unArchiveImage() -> UIImage? {
    
    guard let localURL = self.urlLocal else {
      print("self.urlLocal nf")
      return nil
    }
    guard let bundleURL = self.urlLocal, let imageData = try? Data(contentsOf: bundleURL) else {
      //      print("SwiftGif: This image named \"\(gifUrl)\" does not exist")
      print("unArchiveImage failed")
      return nil
    }
    //self.image = UIImage(data: data)
    //        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "play", withExtension: "gif")!)
    //        let imageData = try? Data(contentsOf: url(forResource: "play", withExtension: "gif")!)
    
    //todo
    //    if let img = NSKeyedUnarchiver.unarchiveObject(with: imageData) as! UIImage! {
    //      return img
    //    }
    return nil
    //    if let resultImg = imageData as UIImage!{
    //      return resultImg
    //    }
  }
  
  func archiveImage() { //image: UIImage) {
    let randomFilename = UUID().uuidString
    let imgData = NSKeyedArchiver.archivedData(withRootObject: self.image as Any)
    self.urlLocal = self.getDocumentsDirectory().appendingPathComponent(randomFilename)
    do {
      try imgData.write(to: self.urlLocal!)
    } catch {print("Couldn't write file")}
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
}

//0.0
//    getDataFromUrl(url: self.urlRemote) { (data, response, error)  in
//
//      guard let data = data, error == nil else { return }
//
//      self.count()
//      DispatchQueue.main.async() { () -> Void in
//        imageVw.image = UIImage(data: data)
////        self.stored = true
//        self.finishedLoading = true
//      }
//
//    }


//  }


