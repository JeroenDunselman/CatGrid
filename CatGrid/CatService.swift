//
//  CatService.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation

class CatService : NSObject, XMLParserDelegate {
  
  let catAPIBaseURL:String = "http://thecatapi.com/api/images/get?format=xml&results_per_page=10&type=gif"
  var catItems:[Item] = []

  var availability:Bool = true
  var serviceAvailabilityTimer:Timer?
  
  let catVC:ViewController?
  init(vc: ViewController) {
        catVC = vc
    super.init()
  }
//  func serviceAvailable() -> Bool {
//    return availability
//  }
  func getCats() {
    if availability {
      
      print("getting feline")
      serviceAvailabilityTimer = Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(CatService.releaseService), userInfo: nil, repeats: true)
      availability = false
      catItems = []
      beginParsing()
    } else {
      print("service denied")
    }
  }
  func releaseService() {
    print("service released")
    availability = true
    serviceAvailabilityTimer?.invalidate()
  }
  
  let elementNameOfCatPicUrl:String = "image"
  let keyNameOfCatPicUrl:String = "url"
  
  var parser = XMLParser()
  var elements = NSMutableDictionary()
  var element = NSString()
  var urlCatPic = NSMutableString()
  
  var parsecount: Int = 0
  func beginParsing()
  {
    parsecount += 1
    print("beginParsing \(parsecount)")
    parser = XMLParser(contentsOf:(URL(string:catAPIBaseURL))!)!
    parser.delegate = self //self.catVC
    parser.parse()
    catVC?.tableView!.reloadData()
//    serviceAvailable = !serviceAvailable
  }
  
  //XMLParser Methods
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
  {
    element = elementName as NSString
    if (elementName as NSString).isEqual(to: elementNameOfCatPicUrl)
    {
      elements = NSMutableDictionary()
      elements = [:]
      urlCatPic = NSMutableString()
      urlCatPic = ""
    }
  }
  func parser(_ parser: XMLParser, foundCharacters string: String)
  {
    if element.isEqual(to: keyNameOfCatPicUrl) {
      urlCatPic.append(string)
    }
  }
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
  {
    if (elementName as NSString).isEqual(to: elementNameOfCatPicUrl) {
      if !urlCatPic.isEqual(nil) {
        elements.setObject(urlCatPic, forKey: keyNameOfCatPicUrl as NSCopying)
      }
      let i:Item = Item(info: elements)
      catItems.append(i)
    }
  }
}

