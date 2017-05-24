//
//  MapsHandler.swift
//
//  Created by Gilson Gil on 3/9/16.
//  Copyright © 2016 doisdoissete. All rights reserved.
//

import MapKit

struct MapsHandler {
  static func open(query: String, from viewController: UIViewController) {
    let hasGoogleMaps = canOpenApp(with: "comgooglemaps://")
    if hasGoogleMaps {
      if #available(iOS 8.0, *) {
        let alertController = UIAlertController(title: "Escolha um aplicativo", message: nil, preferredStyle: .actionSheet)
        let googleAction = UIAlertAction(title: "Google Maps", style: .default) { _ in
          openGoogleMaps(query: query)
        }
        alertController.addAction(googleAction)
        let appleAction = UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
          self.openMaps(query: query)
        })
        alertController.addAction(appleAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
      } else {
        let actionSheet = UIActionSheet(title: "Escolha um aplicativo", delegate: viewController as? UIActionSheetDelegate, cancelButtonTitle: "Cancelar", destructiveButtonTitle: nil, otherButtonTitles: "Google Maps", "Apple Maps")
        actionSheet.show(in: viewController.view)
      }
    } else {
      openMaps(query: query)
    }
  }
  
  private static func canOpenApp(with urlString: String) -> Bool {
    guard let url = URL(string: urlString) else {
      return false
    }
    return UIApplication.shared.canOpenURL(url)
  }
  
  static func openGoogleMaps(query: String) {
    let normalizedQuery = query.replacingOccurrences(of: " ", with: "+").folding(options: .diacriticInsensitive, locale: .current)
    let urlString = "comgooglemaps://?q=\(normalizedQuery)&zoom=16"
    if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
      UIApplication.shared.openURL(url)
    }
  }
  
  static func openMaps(query: String) {
    let urlString = "http://maps.apple.com/?address=\(query)"
    if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
      UIApplication.shared.openURL(url)
    }
  }
}
