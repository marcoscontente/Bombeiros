//
//  LicencaCell.swift
//  AVCB
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

final class LicencaCell: UITableViewCell {
  @IBOutlet weak var typeImageView: UIImageView!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var logradouroLabel: UILabel!
  
  func configure(_ info: String?, logradouro: String?, tipoLicenca: String?) {
    infoLabel.text = info
    logradouroLabel.text = logradouro
    guard let tipoLicenca = tipoLicenca else {
      return
    }
    switch tipoLicenca {
    case "AVCB":
      typeImageView.image = UIImage(named: "az")
    case "CLCB":
      typeImageView.image = UIImage(named: "ver")
    case "TAACB":
      typeImageView.image = UIImage(named: "am")
    default:
      break
    }
  }
}
