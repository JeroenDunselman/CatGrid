//
//  MessengerService.swift
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
  var client: MessengerVC?
  var urlService: Parser?
  var gifRequests:[GifRequest]? = []
  
  func initData() {
    urlService?.getCats()
  }
  
  func makeRequest(num: Int) {
    for _ in 0..<num { addRequest() }
  }
  func addRequest() {
    let resultUrl:String = (urlService?.urlString())!
    let request:GifRequest = GifRequest(url: resultUrl)
    //  print("\(request.gifLocation)")
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
    print("GAS")
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
    //todo attempt unarchive
    //if
    return nil
  }
  
  func rowInfo(row: Int) -> UIImage? {//String {
    
    //find assigned
    let result: UIImage? = findImageFor(row: row)
    if !(result == nil){
      return result!
    }
    
    //find available to assign to row
    let available = availableImage(row: row)
    let testAvailable:Bool = (available != nil)
    if testAvailable {
      let testImg: UIImage? = available!.image
      if !(testImg as UIImage! == nil) {
        return testImg
      }
      return nil
    }
    //    return "\(row), \(boolTest), \(resultUrl)"
    //    return ""
    return nil
  }
  
  public func startLoading(msg: String) {
//    print("MessengerService.parser.startLoading msg \(msg)")
    client?.startLoading(msg: "Hi from MessengerService")
  }
  func finishLoading(msg: String) {
    print("MessengerService.parser.finishLoading msg \(msg)")
    //init availableItems
    self.gifRequests = []
  }
  init(vc: MessengerVC) {
    super.init()
    client = vc
    urlService = Parser(client: self)
  }
}
