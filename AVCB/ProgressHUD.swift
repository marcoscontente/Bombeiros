//
//  ProgressHUD.swift
//
//  Created by Gilson Gil on 27/01/17.
//  Copyright © 2017 prodesp. All rights reserved.
//

import UIKit

final class ProgressHUD: UIView {
  fileprivate let hMargin = CGFloat(12)
  fileprivate let vMargin = CGFloat(6)
  
  fileprivate let activityIndicator: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView()
    activity.translatesAutoresizingMaskIntoConstraints = false
    activity.startAnimating()
    activity.hidesWhenStopped = true
    return activity
  }()
  
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    label.numberOfLines = 0
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    return label
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init(title: String) {
    super.init(frame: .zero)
    label.text = title
    setUp()
  }
  
  private func setUp() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = UIColor(white: 0, alpha: 0.41)
    layer.cornerRadius = 8
    
    let metrics = ["hMargin": hMargin, "vMargin": vMargin]
    var views = [String: AnyObject]()
    
    addSubview(activityIndicator)
    views["activityIndicator"] = activityIndicator
    
    addSubview(label)
    views["label"] = label
    
    let activityHConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
    addConstraint(activityHConstraint)
    let labelHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hMargin-[label]-hMargin-|", options: [], metrics: metrics, views: views)
    addConstraints(labelHConstraints)
    
    let activityVConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    addConstraint(activityVConstraint)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[activityIndicator]-vMargin-[label]-vMargin-|", options: [], metrics: metrics, views: views)
    addConstraints(vConstraints)
  }
}

// MARK: - Public
extension ProgressHUD {
  static func present(with title: String, in view: UIView) -> ProgressHUD {
    view.isUserInteractionEnabled = false
    let progressHUD = ProgressHUD(title: title)
    view.addSubview(progressHUD)
    
    let xConstraint = NSLayoutConstraint(item: progressHUD, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    view.addConstraint(xConstraint)
    let yConstraint = NSLayoutConstraint(item: progressHUD, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
    view.addConstraint(yConstraint)
    let wConstraint = NSLayoutConstraint(item: progressHUD, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
    view.addConstraint(wConstraint)
    let wConstraint2 = NSLayoutConstraint(item: progressHUD, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 130)
    view.addConstraint(wConstraint2)
    let hConstraint = NSLayoutConstraint(item: progressHUD, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
    view.addConstraint(hConstraint)
    let hConstraint2 = NSLayoutConstraint(item: progressHUD, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
    view.addConstraint(hConstraint2)
    
    return progressHUD
  }
  
  func dismiss() {
    DispatchQueue.main.async {
      self.superview?.isUserInteractionEnabled = true
      self.removeFromSuperview()
    }
  }
}
