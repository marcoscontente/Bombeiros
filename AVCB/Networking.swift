//
//  Networking.swift
//  AVCB
//
//  Created by Gilson Gil on 30/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import Foundation

protocol NetworkingProtocol {
  var path: String { get }
  var params: [String: AnyObject] { get }
  init?(_ json: [String: AnyObject])
  
  static var path: String { get }
  static var params: [String: AnyObject] { get }
}

extension NetworkingProtocol {
  var path: String {
    return ""
  }
  
  var params: [String: AnyObject] {
    return [:]
  }
  
  init?(_ json: [String: AnyObject]) {
    return nil
  }
  
  static var path: String {
    return ""
  }
  
  static var params: [String: AnyObject] {
    return [:]
  }
}

enum Networking {
  static let defaultError = NSError(domain: "AVCB", code: -1, userInfo: ["localizedDescription": "Erro desconhecido"])
  private static var baseURL: String {
    if let path = Bundle.main.path(forResource: "AVCB-Configuracoes", ofType: "plist") {
      let dict = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
      return dict?["Base_Url"] as? String ?? ""
    } else {
      return ""
    }
  }
  
  static func get(_ networkingType: NetworkingProtocol.Type, completion: @escaping (_ inner: () throws -> AnyObject?) -> ()) {
    let api = ApiClientRepository()
    api.get(baseURL + networkingType.path, params: networkingType.params) { success, result in
      guard success else {
        completion { throw result as? NSError ?? Networking.defaultError }
        return
      }
      if let results = result as? [[String: AnyObject]], results.count > 0 {
        let objects = results.flatMap {
          networkingType.init($0)
        }
        if objects.count > 0 {
          completion { return objects as AnyObject }
        } else {
          completion { return result }
        }
      } else {
        completion { return result }
      }
    }
  }
  
  static func get(_ networking: NetworkingProtocol, completion: @escaping (_ inner: () throws -> AnyObject?) -> ()) {
    let api = ApiClientRepository()
    api.get(baseURL + networking.path, params: networking.params) { success, result in
      guard success else {
        completion { throw result as? NSError ?? Networking.defaultError }
        return
      }
      if let results = result as? [[String: AnyObject]], results.count > 0 {
        let type = Mirror(reflecting: networking).subjectType as! NetworkingProtocol.Type
        let objects = results.flatMap {
          type.init($0)
        }
        if objects.count > 0 {
          completion { return objects as AnyObject }
        } else {
          completion { return result }
        }
      } else {
        completion { return result }
      }
    }
  }
  
  static func post(_ networkingType: NetworkingProtocol.Type, completion: @escaping (_ inner: () throws -> AnyObject?) -> ()) {
    let api = ApiClientRepository()
    api.post(baseURL + networkingType.path, params: networkingType.params) { success, result in
      guard success else {
        completion { throw result as? NSError ?? Networking.defaultError }
        return
      }
      completion { return result }
    }
  }
  
  static func post(_ networking: NetworkingProtocol, completion: @escaping (_ inner: () throws -> AnyObject?) -> ()) {
    let api = ApiClientRepository()
    api.post(baseURL + networking.path, params: networking.params) { success, result in
      guard success else {
        completion { throw result as? NSError ?? Networking.defaultError }
        return
      }
      completion { return result }
    }
  }
}
