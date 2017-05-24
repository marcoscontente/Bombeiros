//
//  Alert.swift
//  AVCB
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

final class Alert: NSObject {
  static func present(error: NSError, in viewController: UIViewController?) {
    let message = error.localizedDescription
    present(title: nil, message: message, in: viewController)
  }
  
  static func present(title: String?, message: String?, in viewController: UIViewController?) {
    DispatchQueue.main.async {
      if #available(iOS 8.0, *) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController?.present(alertController, animated: true, completion: nil)
      } else {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
      }
    }
  }
}
