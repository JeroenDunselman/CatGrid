//
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class GifService: NSObject {
  
  var client: CatGifVC?
  var urlService: URLService?
  var gifRequests: [GifRequest] = []
  
  init(viewcontroller: CatGifVC) {
    super.init()
    
    client = viewcontroller
    urlService = URLService(client: self)
  }
  
  func findImageFor(row: Int) -> UIImage? {
    
    //  Check if a request was already assigned to row.
    let requestForRow = gifRequests.filter{($0.assignedToRow == row)}
    if !requestForRow.isEmpty { //
      print("found request assigned to row \(row).\(gifRequests.count)")
      
      //  In case specialrequest, returned img might be nil unless request finished.
      return requestForRow.first?.image
    }
    
    //  Find assignable img.
    let freshIn = gifRequests
      .filter{($0.finished)}
      .filter{($0.assignedToRow == nil)}
      if !freshIn.isEmpty { //
        print("found img assignable to row \(row).\(gifRequests.count)")

      //  Check out.
      freshIn.first?.assignedToRow = row
      //  Replenish.
      request()
      
      return freshIn.first?.image
    }
    
    //  Increase buffer size.
    request()
    //  Image fails.
    return nil
  }
  
  func request() {
      guard let url:String = urlService?.url() else {return}
      let request = GifRequest(gifLocation: url)
      request.downloadImage()
      
      gifRequests.append(request)
  }

  func request(row: Int, imageView: UIImageView) {
    
    //  Prevent repeating request for recurring row.
    if (!gifRequests.filter{($0.assignedToRow == row)}.isEmpty) {return}
    
    guard let url:String = urlService?.url() else {return}
    let request = GifRequest(gifLocation: url)
    gifRequests.append(request)
    
    //  Supply the imageview of requesting cell, to show image in once it becomes available.
    request.downloadImage(row: row, imageVw: imageView)
  }
  
  //  Init gifRequests, retain unviewed.
  func refresh() {
    gifRequests = gifRequests.filter{($0.assignedToRow == nil)}
    //    print("gifRequests.count after refresh: \(gifRequests.count)")
  }
  
  func unAssignAvailableImages() {
    for request in gifRequests.filter({($0.finished)}) {
      request.assignedToRow = nil
    }
  }

}


