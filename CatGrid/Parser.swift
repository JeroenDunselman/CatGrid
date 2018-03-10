//
//  Parser.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation

protocol ParserClient: NSObjectProtocol {
  func parseStarted(msg: String)
  func initialParseFinished(msg: String)
  func parseFinished(msg: String)
}

class Parser : NSObject, XMLParserDelegate  {
  var catAPIBaseURL = ""
  public var parseResult:[String] = []
  
  var client: GifService?
  
  let batchSize: Int = 20
  var threshHold: Int = 0
  
  var urlsViewed: [String] = []

  init (client: GifService) {
    super.init()
    
    self.client = client
    client.parseStarted(msg: "Hi from parser init()")
    
    catAPIBaseURL = String("http://thecatapi.com/api/images/get?format=xml&results_per_page=\(batchSize)&type=gif")
    
    threshHold = self.batchSize / 2
    beginParsing(initializing: true)
  }
  
  func beginParsing(initializing: Bool) {
//    DispatchQueue.main.async() { () -> Void in
    self.parser = XMLParser(contentsOf:(URL(string:self.catAPIBaseURL))!)!
    self.parser.delegate = self
    self.parser.parse()
    if !initializing {
      self.client?.parseFinished(msg: "Hi from parser after parse")
      
    } else {
      self.client?.initialParseFinished(msg: "Hi from parser after initial parse")
    }
//    }
  }
  
  func urlString() -> String? {

    // more urls needed? check size
    if parseResult.count < threshHold {
      // trigger next batch
        self.beginParsing(initializing: false)
    }

    while parseResult.count > 0 {
      let result = parseResult.removeFirst()
      
      //prevent previously viewed images
      if !urlsViewed.contains(result) {
        
        //track viewed
        urlsViewed.append(result) //parseResult.first!)
        return result
      }
      //      else { print("rejected url urlsViewed \(urlsViewed.count)") }, retry
    }
    
    return nil
  }
  
  let elementNameOfCatGifUrl:String = "image"
  let keyNameOfCatPicUrl:String = "url"
  
  var parser = XMLParser()
  var elements = NSMutableDictionary()
  var element = NSString()
  var urlCatGif = NSMutableString()
  
  //XMLParser Methods
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    element = elementName as NSString
    if (elementName as NSString).isEqual(to: elementNameOfCatGifUrl)
    {
      elements = NSMutableDictionary()
      elements = [:]
      urlCatGif = NSMutableString()
      urlCatGif = ""
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    if element.isEqual(to: keyNameOfCatPicUrl) {
      urlCatGif.append(string)
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if (elementName as NSString).isEqual(to: elementNameOfCatGifUrl) {
      if !urlCatGif.isEqual(nil) {
        parseResult.append(stringCheck(str: urlCatGif as String))
      }
    }
  }
  
  func stringCheck(str: String) -> (String) {
    return str.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "{f}", with: "", options: NSString.CompareOptions.literal, range:nil)
  }
  
}
