//
//  GoogleStaticMapsHelper.swift
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

struct GoogleStaticMapsHelper {
  fileprivate static let googleMapsAPIKey = "AIzaSyCrjFheBvKAAcs2Mfa14gKhlRWVOIsodAs"
  fileprivate static let googleMapsBaseUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&key=\(GoogleStaticMapsHelper.googleMapsAPIKey)&center="
  
  static func map(for query: String, size: CGSize, completion: @escaping (_ inner: () throws -> UIImage) -> ()) {
    let commaSeparatedDiacriticQuery = query.replacingOccurrences(of: " ", with: "+").folding(options: .diacriticInsensitive, locale: .current)
    let url = googleMapsBaseUrl + commaSeparatedDiacriticQuery + "&size=\(String(format: "%.0fx%.0f", arguments: [size.width, size.height]))&scale=\(String(format: "%.0f", arguments: [UIScreen.main.scale]))&markers=color:0x990000|" + commaSeparatedDiacriticQuery
    let api = ApiClientRepository()
    api.get(url) { success, result in
      guard success, let data = result as? Data, let image = UIImage(data: data) else {
        completion { throw Networking.defaultError }
        return
      }
      completion { return image }
    }
  }
}
