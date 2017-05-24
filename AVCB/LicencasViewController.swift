//
//  LicencasViewController.swift
//  AVCB
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

class LicencasViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var municipioLabel: UILabel!
  @IBOutlet weak var logradouroLabel: UILabel!
  @IBOutlet weak var bairroLabel: UILabel!
  
  var licencas = [Licenca]()
  var municipio: Municipio?
  var logradouro: Logradouro?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableViewAutomaticDimension
    municipioLabel.text = municipio?.descricao
    logradouroLabel.text = logradouro?.descricaoLogradouro
    bairroLabel.text = logradouro?.descricaoBairro
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    guard let licencaDetailViewController = segue.destination as? LicencaDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    let licenca = licencas[indexPath.row]
    licencaDetailViewController.licenca = licenca
  }
}

// MARK: - Actions
extension LicencasViewController {
  @IBAction func infoTapped() {
    let title = "Tipos de Licença"
    let message = "- Cor verde para licenças do tipo CLCB\n-Cor amarelo para licenças do tipo TAACB\n-Cor azul para licenças do tipo AVCB"
    if #available(iOS 8.0, *) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    } else {
      // Fallback on earlier versions
      let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
      alertView.show()
    }
  }
}

// MARK: - UITableView DataSource
extension LicencasViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return licencas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LicencaCell else {
      return UITableViewCell()
    }
    
    let licenca = licencas[indexPath.row]
    cell.configure(licenca.descricaoOcupacao, logradouro: licenca.descricaoLogradouro + ", " + licenca.descricaoBairro, tipoLicenca: licenca.descricaoTipoLicenca)
    return cell
  }
}
