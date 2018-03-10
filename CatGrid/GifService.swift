//
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

protocol MessageView: NSObjectProtocol {
  func startLoadingMessageView(msg: String)
  func finishLoadingMessageView()
}

class GifService: NSObject, ParserClient {
  var client: CatGifVC?
  var urlService: Parser?
  var gifRequests: [GifRequest] = []
  
  var replenishing = false
  var pressure = 0
  
  init(vc: CatGifVC) {
    super.init()
    client = vc
    urlService = Parser(client: self)
  }
  
  func findImageFor(row: Int) -> UIImage? {
    
    //check if a request was already assigned to row
    let requestForRow = gifRequests.filter{($0.assignedToRow == row)}
    if !requestForRow.isEmpty {
      
      print("found request assigned to row \(row).\(gifRequests.count)")
      
      //in case specialrequest, img might be nil unless .finishedLoading
      return requestForRow.first?.image
    }
    
    //find assignable img
    let freshIn = gifRequests
      .filter{($0.assignable)}
      .filter{($0.assignedToRow == nil)}
    if !freshIn.isEmpty {
      
      print("found img assignable to row \(row).\(gifRequests.count)")

      //  check out
      freshIn.first?.assignedToRow = row
      //  replenish
      request()
      
      return freshIn.first?.image
    }
    
    //  replenish
    request()
    //  image fails
    return nil
  }
  
  func request() {
    if let url:String = urlService?.urlString() {
      let request:GifRequest = GifRequest(url: url)
      request.downloadImage()
      
      gifRequests.append(request)
    } else {
      print("wtf")
    }
  }

  func specialRequest(row: Int, imageView: UIImageView) {
    //create request supplying the imageview of requiring cell, to show image in once it becomes available
    
    //prevent repeating request for recurring row
    let existingForRow = gifRequests.filter{($0.assignedToRow == row)}
    
    if existingForRow.isEmpty {
      //create request 
      if let url:String = urlService?.urlString() {
        let request:GifRequest = GifRequest(url: url)
        
        request.downloadImage(row: row, imageVw: imageView)
        
        gifRequests.append(request)
        print("specialRequest gifRequests.count: \(gifRequests.count)")
      } else {
        print("wtf")
      }
    }
    
  }
  
  func refresh() {
    //init gifRequests, retain unviewed
    print("gifRequests.count: \(gifRequests.count)")
    self.gifRequests = self.gifRequests.filter{($0.assignedToRow == nil)}
    print("gifRequests.count: \(gifRequests.count)")
  }
  
  public func parseStarted(msg: String) {
    client?.startLoadingMessageView(msg: "GifService.startLoading \" \(msg) \"")
  }
  
  func parseFinished(msg: String) {
    print("GifService.ParserClient finished parse with msg \(msg)")
//    client?.finishLoadingMessageView()
  }
  func initialParseFinished(msg: String) {
    print("GifService.ParserClient finished initial parse with msg \(msg)")
    client?.finishLoadingMessageView()
  }
}

//  func replenish() {
//
//    if gifRequests.count > 100 { return }
////    pressure += 1
////    if !replenishing {
////      replenishing = true
//      let size = 1 //+ pressure //max(25 - (gifRequests.count), 0) //12 //
//
//      if size > 0 {        print("replenish size: \(size)")}
//      DispatchQueue.main.async() { () -> Void in
//        for _ in 0..<size { self.request() }
//        self.pressure = 0
////        self.replenishing = false
//      }
////    }
//  }

//  func availableImage(row: Int) -> GifRequest? {
//    let optionalRequests: [GifRequest]? = gifRequests
//    let requests = optionalRequests ?? []
//
//    let freshIn = requests
////      .filter{($0.finishedLoading)}
//      .filter{($0.assignedToRow == nil)}
//    if !freshIn.isEmpty {
////      assign request to row
//      freshIn.first?.assignedToRow = row
//      return freshIn.first
//    }
//
//    //imgs failing, so step on it
//    makeRequest(num: 5)
//    return nil
//  }
//  func rowInfo(row: Int) -> UIImage? {
//
//    //attempt already assigned to row
//    let result: UIImage? = findImageFor(row: row)
//    if !(result == nil){
//      return result!
//    }
//
//    //try currently available to assign to row
//    let available = availableImage(row: row)  //: GifRequest
//    let testAvailable:Bool = (available != nil)
//    if testAvailable {
//      let testImg: UIImage? = available!.image
//      if !(testImg as UIImage! == nil) {
//        return testImg
//      }
//      return nil
//    }
//    return nil
//  }
