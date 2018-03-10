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

class URLService : NSObject {
  
  var parser = XMLParser()
  var elements = NSMutableDictionary()
  var element = NSString()
  var resultURL = NSMutableString()
  
  var catAPIBaseURL = ""
  let batchSize: Int = 40
  var threshHold: Int = 0
  
  let elementNameOfCatGifUrl:String = "image"
  let keyNameOfCatGifUrl:String = "url"
  
  public var parseResult:[String] = []
  var client: GifService?

  var urlsServed: [String] = []

  init (client: GifService) {
    super.init()
    
    self.client = client
    client.parseStarted(msg: "Hi from parser init()")
    
    catAPIBaseURL = String("http://thecatapi.com/api/images/get?format=xml&results_per_page=\(batchSize)&type=gif")
    
    threshHold = self.batchSize / 2
    beginParsing(initializing: true)
  }
  
  func urlString() -> String? {

    // replenish? check size
    if parseResult.count < threshHold {
      // trigger next batch
      self.beginParsing(initializing: false)
    }

    //make sure urlString is fresh
    while parseResult.count > 0 {
      let result = parseResult.removeFirst()
      
      //return only if not previously viewed
      if !urlsServed.contains(result) {
        //track served urls for future reference
        urlsServed.append(result)
        return result
      }// else { print("rejected url urlsServed \(urlsServed)") }
    }
    
    return nil
  }
}

extension URLService: XMLParserDelegate {

  func beginParsing(initializing: Bool) {
    
    self.parser = XMLParser(contentsOf:(URL(string:self.catAPIBaseURL))!)!
    self.parser.delegate = self
    self.parser.parse()
    if !initializing {
      self.client?.parseFinished(msg: "Hi from parser after parse")
      
    } else {
      self.client?.initialParseFinished(msg: "Hi from parser after initial parse")
    }
    
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
