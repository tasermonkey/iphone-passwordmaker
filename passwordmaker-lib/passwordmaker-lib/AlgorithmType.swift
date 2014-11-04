//
//  AlgorithmType.swift
//  passwordmaker-lib
//
//  Created by James Stapleton on 2014/9/21.
//  Copyright (c) 2014 tasermonkeys. All rights reserved.
//

import Foundation

enum AlgorithmType: Int {
  case MD4 = 1
  case MD5 = 2
  case SHA1 = 3
  case SHA256 = 4
  case RIPEMD160 = 5
  
  func name() -> String {
    switch self {
    case .MD4:
        return "MD4"
    case .MD5:
      return "MD5"
    case .SHA1:
      return "SHA1"
    case .SHA256:
      return "SHA256"
    case .RIPEMD160:
      return "RIPEMD160"
    }
    func hmacName() -> String {
      let n = name()
      return "HMAC-\(n)"
    }
    func rdfTagName() -> String {
      switch self {
      case .RIPEMD160:
        return "rmd160"
      default:
        return name().lowercaseString
      }
    }
    func rdfHMacName() -> String {
      let rtn = rdfTagName()
      switch self {
      case .SHA256:
        return "hmac-\(rtn)-fixed"
      default:
        return "hmac-\(rtn)"
      }
    }
  }
  
}