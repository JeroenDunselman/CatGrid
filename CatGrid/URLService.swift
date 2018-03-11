//
//  Parser.swift
//  CatGrid
//
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation

class URLService : NSObject {
  
  //  Requests and replenishes urls of gifs of cats by batch.
  var catAPIBaseURL = ""
  let batchSize: Int = 50
  var threshHoldSize: Int = 0
  
  //  Parses responses.
  let elementNameOfCatGifUrl = "image"
  let keyNameOfCatGifUrl = "url"
  var elements = NSMutableDictionary()
  var element = NSString()
  var resultURL = NSMutableString()
  public var parseResult:[String] = []
  
  //  Makes unique urls available to client.
  var urlsServed: [String] = []
  var client: GifService?
  
  init (client: GifService) {
    super.init()
    
    self.client = client
    catAPIBaseURL = String("http://thecatapi.com/api/images/get?format=xml&results_per_page=\(batchSize)&type=gif")
    
    threshHoldSize = self.batchSize / 2
    beginParsing(initializing: true)
  }
  
  func url() -> String? {

    //  Replenish? Check size.
    if parseResult.count < threshHoldSize {
      //  Trigger next batch.
      self.beginParsing(initializing: false)
    }

    //  Only fresh urls.
    while parseResult.count > 0 {
      let result = parseResult.removeFirst()
      
      //  Return if not previously served.
      if !urlsServed.contains(result) {
        //  Register served urls for future reference.
        urlsServed.append(result)
        
        return result
      } 
    }
    
    return nil
  }
  
}

extension URLService: XMLParserDelegate {

  func beginParsing(initializing: Bool) {
    var parser = XMLParser()

    parser = XMLParser(contentsOf:(URL(string:self.catAPIBaseURL))!)!
    parser.delegate = self
    parser.parse()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
    element = elementName as NSString
    if (elementName as NSString).isEqual(to: elementNameOfCatGifUrl)
    {
      elements = NSMutableDictionary()
      elements = [:]
      resultURL = ""
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    if element.isEqual(to: keyNameOfCatGifUrl) {
      resultURL.append(string)
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if (elementName as NSString).isEqual(to: elementNameOfCatGifUrl) {
      if !resultURL.isEqual(nil) {
        parseResult.append(stringCheck(str: resultURL as String))
      }
    }
  }
  
  func stringCheck(str: String) -> (String) {
    return str.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "{f}", with: "", options: NSString.CompareOptions.literal, range:nil)
  }
  
}
