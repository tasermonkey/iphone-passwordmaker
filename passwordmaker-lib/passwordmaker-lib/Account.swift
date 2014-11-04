//
//  Account.swift
//  passwordmaker-lib
//
//  Created by James Stapleton on 2014/9/21.
//  Copyright (c) 2014 tasermonkeys. All rights reserved.
//

import Foundation

class Account {
  let id: String
  var name: String = ""
  var desc: String = ""
  var url: String = ""
  var username: String = ""
  var algorith:AlgorithmType = .MD5
  var hmac:Bool = false
  var trim:Bool = true
  var length:Int = 8
  var characterSet:String = "0123456789abcedf"
  var leetType:LeetType = .None
  var leetLevel:LeetLevel = .Level1
  var modifier:String = ""
  var prefix:String = ""
  var suffix:String = ""
  var autoPop:Bool = false
  var urlComponents:NSMutableSet = NSMutableSet()
  
  
  init(id:String) {
    self.id = id
  }
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
  
  class func createId() -> String {
    return filter("rdf:#$" + NSUUID.UUID().UUIDString, {+$0 != "-"})
  }
}