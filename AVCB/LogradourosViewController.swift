//
//  LogradourosViewController.swift
//  AVCB
//
//  Created by Gilson Gil on 31/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

class LogradourosViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate weak var progressHUD: ProgressHUD?
  
  var logradouros = [Logradouro]()
  var municipio: Municipio?
  var numero: String?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    if let licencasViewController = segue.destination as? LicencasViewController, let licencas = sender as? [Licenca] {
      licencasViewController.licencas = licencas
      licencasViewController.municipio = municipio
      if let indexPath = tableView.indexPathForSelectedRow {
        licencasViewController.logradouro = logradouros[indexPath.row]
      }
    }
  }
}

// MARK: - UITableView DataSource
extension LogradourosViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return logradouros.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
      return UITableViewCell()
    }
    
    let logradouro = logradouros[indexPath.row]
    cell.textLabel?.text = logradouro.descricaoLogradouro + " - " + logradouro.descricaoBairro
    return cell
  }
}

// MARK: - UITableView Delegate
extension LogradourosViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let logradouro = logradouros[indexPath.row]
    progressHUD = ProgressHUD.present(with: "Buscando licenças", in: view)
    municipio?.licencas(with: logradouro.codigoLogradouro, number: numero) { [weak self] inner in
      self?.progressHUD?.dismiss()
      do {
        let licencas = try inner()
        DispatchQueue.main.async {
          self?.performSegue(withIdentifier: "SegueLicencas", sender: licencas)
        }
      } catch {
        Alert.present(title: "Atenção", message: "Nenhum registro encontrado", in: self)
      }
    }
  }
}
