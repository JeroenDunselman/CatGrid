//
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

protocol MessageView: NSObjectProtocol {
  func startLoading(msg: String)
  func finishLoading()
}

class GifService: NSObject, ParserClient {
  var client: CatGifVC?
  var urlService: Parser?
  var gifRequests:[GifRequest]? = []
  
  func getCats() {
    urlService?.initData()
  }
  
  func makeRequest(num: Int) {
    for _ in 0..<num { addRequest() }
  }
  
  func addRequest() {
    let resultUrl:String = (urlService?.urlString())!
    let request:GifRequest = GifRequest(url: resultUrl)
    request.downloadImage()
    gifRequests!.append(request)
  }

  func availableImage(row: Int) -> GifRequest? {
    let optionalRequests: [GifRequest]? = gifRequests
    let requests = optionalRequests ?? []
    
    let freshIn = requests
      .filter{($0.finishedLoading)}
      .filter{($0.assignedToRow == nil)}
    if !freshIn.isEmpty {
      freshIn.first?.assignedToRow = row
      return freshIn.first
    }
    
    //imgs failing, so step on it
    makeRequest(num: 15)
    return nil
  }
  
  func findImageFor(row: Int) -> UIImage?{
    let optionalRequests: [GifRequest]? = gifRequests
    let requests = optionalRequests ?? []
    
    let forRow = requests
      .filter{($0.finishedLoading)}
      .filter{($0.assignedToRow == row)}
    if !forRow.isEmpty {
      return forRow.first?.image
    }
    
    return nil
  }
  
  func rowInfo(row: Int) -> UIImage? {
    
    //attempt already assigned to row
    let result: UIImage? = findImageFor(row: row)
    if !(result == nil){
      return result!
    }
    
    //attempt currently available to assign to row
    let available = availableImage(row: row)
    let testAvailable:Bool = (available != nil)
    if testAvailable {
      let testImg: UIImage? = available!.image
      if !(testImg as UIImage! == nil) {
        return testImg
      }
      return nil
    }
    return nil
  }
  
  func specialRequest(row: Int, imageView: UIImageView) {
    let resultUrl:String = (urlService?.urlString())!
    let request:GifRequest = GifRequest(url: resultUrl)
    request.downloadImage(row: row, imageVw: imageView)
    gifRequests!.append(request)
  }
  
  public func startLoading(msg: String) {
    client?.startLoading(msg: "Hi from GifService")
  }
  func finishLoading(msg: String) {
    print("GifService.parser.finishLoading msg \(msg)")
    
    //init availableItems
    self.gifRequests = []
  }
  init(vc: CatGifVC) {
    super.init()
    client = vc
    urlService = Parser(client: self)
  }
}
