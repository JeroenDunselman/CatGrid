////
////  CatService.swift
////  CatGrid
////
////  Created by Jeroen Dunselman on 29/03/2017.
////  Copyright © 2017 Jeroen Dunselman. All rights reserved.
////
//
//import Foundation
//import UIKit
//protocol CatView: NSObjectProtocol {
//  func startLoading()
//  func finishLoading()
//}
//
//class CatService : NSObject, XMLParserDelegate {
//  
//  let catAPIBaseURL:String = "http://thecatapi.com/api/images/get?format=xml&results_per_page=120&type=gif"
//  var urlBase:[String] = []
////  {
////    didSet {
////      if urlBase.count < 50 {
////        print("replenish")
////        DispatchQueue.global(qos: .userInitiated).async {
////          self.parser.parse()
////        }
////      }
////    }
////  }
//  
////  var catItems:[LoadItem] = []
//  
//  
//  //niu
//  let countListItems = 100
//  let sizeBatch = 20
//  var batchItemsCount : Int = 0
//    //  var viewBuffer:[ViewItem]
//  
//  var availability:Bool = true
//  var serviceAvailabilityTimer:Timer?
//  
//  let catVC:ViewController?
//  
//
//  
//  //  var parsecount: Int = 0
//  func beginParsing()
//  {
//    parser = XMLParser(contentsOf:(URL(string:catAPIBaseURL))!)!
//    parser.delegate = self
//    parser.parse()
//    
//    createLoadBuffer()
//    reload()
//  }
//  
//  struct rowItem {
//    let row:Int
//    let item:LoadItem
//  }
//  var rowItems: [rowItem] = []
//  var loadBuffer:[LoadItem] = [] {
//    didSet {
//    print("didset lbuf")
//      if loadBuffer.count < sizeLoadBuffer {
//      createLoadItem()
//      }
//    }
//  }
//
//  let sizeLoadBuffer: Int = 7
//  func createLoadBuffer() {
//    for _ in 0..<sizeLoadBuffer {
//      createLoadItem()
//    }
//  }
//  public func createLoadItem()  {
//    if urlBase.count > 0 {
//    let strURL = self.urlBase.removeFirst()
//    
//    DispatchQueue.global(qos: .userInitiated).async {
//      let load = LoadItem(url: strURL)
//      load.downloadImage()
//      self.loadBuffer.append(load)
//    }
//    }
//  }
//  
//  var initiated = false
//  func reload() {
//    if !initiated {
//    catVC?.tableView!.reloadData()
//    initiated = true
//    }
//  }
//  
//  func availableImageItem() -> LoadItem? {
//    print("available loaditemsfinishedLoading \(loadBuffer.count)")
//    var imagesAvailable:[LoadItem] = loadBuffer.filter{$0.finishedLoading}
//    if imagesAvailable.count > 0 {
////      DispatchQueue.main.async() { () -> Void in
////      self.image = UIImage.gifImageWithData(data) //imageData!)
////      DispatchQueue.main.async {
//      if let resultItem:LoadItem = imagesAvailable.removeFirst() as LoadItem! {
//        print("removeFirst \(resultItem.urlGif)")
//        return resultItem as LoadItem
////      }
//        
//      }
//    }
//    return nil
//  }
//  
//  func getImageFor(row: Int) -> UIImage? {
//    //existing rowItem(row)?
//    let testRowItem = rowItems.filter{$0.row == row}.first
//    if let existingRowItem:rowItem = testRowItem as rowItem! {
//      if let image = existingRowItem.item.image as UIImage! {
//        return image
//      } else {
//        if let image = existingRowItem.item.unArchiveImage() as UIImage! {
//          return image
//        }
//      }
//    }
//    //try to create rowItem
//    //fresh img available?
//    if let availableImageItem = availableImageItem() as LoadItem!{
//      //register
//      rowItems.append(rowItem(row: row, item: availableImageItem))
//      return availableImageItem.image
//    }
//    
//    //more traffic is needed afh sizeLoadBuffer
//    //doe dit met didset als size <
//    if urlBase.count > 0 {
//    if let nextUrl = urlBase.removeFirst() as String! {
//      let newItem: LoadItem = LoadItem(url: nextUrl)
//      newItem.downloadImage(url: newItem.urlRemote)
//      rowItems.append(rowItem(row: row, item: newItem))
//    }
//    }
//    return nil
//  }
//    
//  func didSelect(row: Int, direction: Bool) -> UIImage? {
//    let rowPrepareImage = direction ? row + 30 : row - 30
//    let rowDismissImage = direction ? row - 30 : row + 30
////    print("prep/dismiss\(rowPrepareImage), \(rowDismissImage)")
//    
//    let testClear = rowItems.filter{$0.row == rowDismissImage}.first
//    if let clearItem:rowItem = testClear as rowItem! {
//      print("clear: \(clearItem)")
//      clearItem.item.clearItem()
//    }
//    
//    let testPrepare = rowItems.filter{$0.row == rowPrepareImage}.first
//    if let prepareItem:rowItem = testPrepare as rowItem! {
//      print("prepare: \(prepareItem)")
//      prepareItem.item.prepareItem()
//      rowItems.append(prepareItem)
//    }
//    
//    return getImageFor(row: row)
//  }
//  
//  func didSelect(row: Int, direction: Bool, view: UIImageView) {
//    if urlBase.count > 0 {
////    if  {
//      let nextUrl = urlBase.removeFirst() as String!
//      let newItem: LoadItem = LoadItem(url: nextUrl!)
//      
////      print(nextUrl ?? "nextUrl")
//      newItem.downloadImage(imageVw: view)
//      rowItems.append(rowItem(row: row, item: newItem))
//    }
//
//  }
//  
//  init(vc: ViewController) {
//    batchItemsCount = 0 //Int(countListItems/sizeBatch)
//    catVC = vc
//    super.init()
//  }
//
//  func getCats() {
//
//    if availability {
//      catVC?.startLoading()
////      print("feline service")
//      serviceAvailabilityTimer = Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(CatService.releaseService), userInfo: nil, repeats: true)
//      availability = false
//      
////      catItems = []
//      self.rowItems = []
//      beginParsing()
//    }
////    else {print("no service")}
//  }
//  
//  func releaseService() {
//    print("service released")
//    availability = true
//    serviceAvailabilityTimer?.invalidate()
//    catVC?.finishLoading()
//  }
//  
//  let elementNameOfCatPicUrl:String = "image"
//  let keyNameOfCatPicUrl:String = "url"
//  
//  var parser = XMLParser()
//  var elements = NSMutableDictionary()
//  var element = NSString()
//  var urlCatPic = NSMutableString()
//  
//
//  
//  //XMLParser Methods
//  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
//  {
//    element = elementName as NSString
//    if (elementName as NSString).isEqual(to: elementNameOfCatPicUrl)
//    {
//      elements = NSMutableDictionary()
//      elements = [:]
//      urlCatPic = NSMutableString()
//      urlCatPic = ""
//    }
//  }
//  
//  func parser(_ parser: XMLParser, foundCharacters string: String)
//  {
//    if element.isEqual(to: keyNameOfCatPicUrl) {
//      urlCatPic.append(string)
//    }
//  }
//  
//  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
//  {
//    if (elementName as NSString).isEqual(to: elementNameOfCatPicUrl) {
//      if !urlCatPic.isEqual(nil) {
//        //1.0
//        urlBase.append(urlCatPic as String)
//        
//        //0.0
////        elements.setObject(urlCatPic, forKey: keyNameOfCatPicUrl as NSCopying)
//      }
//      //0.0
////      let i:LoadItem = LoadItem(info: elements)
////      catItems.append(i)
////      if (batchItemsCount < sizeBatch || batchItemsCount > 10) {
////        i.downloadImage(url: i.urlRemote)
////        batchItemsCount += 1
////      }
//    }
//  }
//}
//
////    if let result = imagesAvailable[0].image as UIImage! {
////      //maak rowItem
////      return result
////    }
////      = loadBuffer.first($0.finishedLoading == true) as UIImage! {
////      return //imageAvailable.image!
////    }
