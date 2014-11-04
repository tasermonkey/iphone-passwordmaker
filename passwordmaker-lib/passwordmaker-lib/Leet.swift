//
//  Leet.swift
//  passwordmaker-lib
//
//  Created by James Stapleton on 2014/9/21.
//  Copyright (c) 2014 tasermonkeys. All rights reserved.
//

import Foundation

enum LeetType:Int {
  case None = 0
  case Before = 1
  case After = 2
  case Both = 3
  
  func name() -> String {
    switch self {
    case .None:
      return "None"
    case .Before:
      return "Before"
    case .After:
      return "After"
    case .Both:
      return "Both"
    }
  }
  func rdfName() -> String {
    switch self {
    case .None:
      return "off"
    case .Before:
      return "before-hashing"
    case .After:
      return "after-hashing"
    case .Both:
      return "both"
    }
  }
}

enum LeetLevel:Int {
  case Level1 = 1
  case Level2 = 2
  case Level3 = 3
  case Level4 = 4
  case Level5 = 5
  case Level6 = 6
  case Level7 = 7
  case Level8 = 8
  case Level9 = 9
  
  func ordinal() -> Int {
    return self.toRaw() - 1
  }
  
}