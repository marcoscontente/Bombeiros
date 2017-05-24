//
//  LicencaDetailViewController.swift
//  AVCB
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit
import CoreLocation

final class LicencaDetailViewController: UIViewController {
  @IBOutlet weak var mapButton: UIButton!
  @IBOutlet weak var avcbLabel: UILabel!
  @IBOutlet weak var situacaoLabel: UILabel!
  @IBOutlet weak var vigenciaLabel: UILabel!
  @IBOutlet weak var razaoSocialLabel: UILabel!
  @IBOutlet weak var enderecoLabel: UILabel!
  @IBOutlet weak var ocupacaoLabel: UILabel!
  @IBOutlet weak var observacoesLabel: UILabel!
  @IBOutlet weak var localizacaoLabel: UILabel!
  
  var licenca: Licenca?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let licenca = licenca else {
      return
    }
    avcbLabel.text = String(licenca.identificadorLicenca)
    situacaoLabel.text = licenca.descricaoSituacaoLicenca
    vigenciaLabel.text = licenca.dataVigencia
    razaoSocialLabel.text = licenca.nomeProprietario
    enderecoLabel.text = "\(licenca.descricaoLogradouro), \(licenca.numeroDoLogradouro), \(licenca.descricaoBairro) - \(licenca.descricaoMunicipio)"
    ocupacaoLabel.text = licenca.descricaoOcupacao
    observacoesLabel.text = licenca.observacaoLicenca
    GoogleStaticMapsHelper.map(for: "\(licenca.descricaoLogradouro),\(licenca.numeroDoLogradouro)", size: mapButton.bounds.size) { [weak self] inner in
      do {
        let image = try inner()
        DispatchQueue.main.async {
          self?.mapButton.setImage(image, for: .normal)
        }
      } catch {
        Alert.present(error: error as NSError, in: self)
      }
    }
    guard CLLocationManager().location != nil, Util.shared().distance > 0 else {
      return
    }
    if Util.shared().distance > 100 {
      localizacaoLabel.text = "A sua localização encontra-se a mais de 100 metros do endereço indicado"
    } else {
      localizacaoLabel.text = "A sua localização encontra-se a menos de 100 metros do endereço indicado"
    }
  }
}

// MARK: - Actions
extension LicencaDetailViewController {
  @IBAction func mapTapped() {
    guard let address = enderecoLabel.text else {
      return
    }
    MapsHandler.open(query: address, from: self)
  }
}

// MARK: - UIActionSheet Delegate
extension LicencaDetailViewController: UIActionSheetDelegate {
  func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
    guard buttonIndex != actionSheet.cancelButtonIndex else {
      return
    }
    guard let address = enderecoLabel.text else {
      return
    }
    if buttonIndex == 0 {
      MapsHandler.openGoogleMaps(query: address)
    } else {
      MapsHandler.openMaps(query: address)
    }
  }
}
