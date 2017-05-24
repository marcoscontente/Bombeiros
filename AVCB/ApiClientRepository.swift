//
//  ApiClientRepository.swift
//  SP Serviço
//
//  Created by Claudio Smith on 04/11/16.
//  Copyright © 2016 prodesp. All rights reserved.
//

import UIKit

class ApiClientRepository: NSObject {
  fileprivate let session = URLSession(configuration: .default)
  
  fileprivate func clientURLRequest(_ path: String, method: String, params: Dictionary<String, AnyObject>? = nil) -> URLRequest {
    var request = URLRequest(url: URL(string: path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
    request.httpMethod = method
    
    if let params = params {
      let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      request.httpBody = jsonData
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    let user: String
    let password: String
    if let path = Bundle.main.path(forResource: "AVCB-Configuracoes", ofType: "plist") {
      let dict = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
      user = dict?["User"] as? String ?? ""
      password = dict?["Password"] as? String ?? ""
      if let version = dict?["Version"] as? String {
        request.setValue(version, forHTTPHeaderField: "Version")
      }
    } else {
      user = ""
      password = ""
    }
    let passwordString = "\(user):\(password)"
    let passwordData = passwordString.data(using: String.Encoding.utf8)
    let base64EncodedCredential = passwordData!.base64EncodedString(options: .lineLength64Characters)
    
    request.setValue("Basic \(base64EncodedCredential)", forHTTPHeaderField: "Authorization")
    
    return request
  }
  
  fileprivate func dataTask(_ request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
    session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      guard error == nil else {
        completion(false, error as AnyObject)
        return
      }
      if let data = data {
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        let result = json ?? data
        if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
          completion(true, result as AnyObject?)
        } else {
          completion(false, result as AnyObject?)
        }
      }
    }) .resume()
  }
  
  func get(_ urlString: String, params: [String: AnyObject]? = nil, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
    let request = clientURLRequest(urlString, method: "GET")
    dataTask(request, completion: completion)
  }
  
  func post(_ urlString: String, params: [String: AnyObject]? = nil, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
    var request = clientURLRequest(urlString, method: "POST")
    if let body = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted) {
//      let bodyString = NSString(bytes: (body as NSData).bytes, length: (body as NSData).length, encoding: 4)
//      request.httpBody = bodyString?.data(using: 4)
      request.httpBody = body
    }
    
//    // setando o body
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:chave options:0 error:nil];
//    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
//    
//    NSString *conteudoBody = jsonString;
//    
//    
//    [request setHTTPBody:[conteudoBody dataUsingEncoding:NSUTF8StringEncoding]];
    dataTask(request, completion: completion)
  }
}
