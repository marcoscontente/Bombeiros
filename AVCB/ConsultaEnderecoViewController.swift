//
//  ConsultaEnderecoViewController.swift
//  AVCB
//
//  Created by Gilson Gil on 27/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

final class ConsultaEnderecoViewController: UITableViewController {
  @IBOutlet weak var municipioTextField: UITextField!
  @IBOutlet weak var enderecoTextField: UITextField!
  @IBOutlet weak var numeroTextField: UITextField!
  @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
  
  fileprivate weak var progressHUD: ProgressHUD?
  
  var municipio: Municipio? {
    didSet {
      municipioTextField.text = municipio?.descricao
    }
  }
}

// MARK: - Segues
extension ConsultaEnderecoViewController {
  @IBAction func unwindFromMunicipio(segue: UIStoryboardSegue) {
    enderecoTextField.isEnabled = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    if let municipioViewController = segue.destination as? MunicipioViewController {
      municipioViewController.selectedMunicipioId = municipio?.codigoMunicipio
    } else if let logradourosViewController = segue.destination as? LogradourosViewController, let logradouros = sender as? [Logradouro] {
      logradourosViewController.municipio = municipio
      logradourosViewController.logradouros = logradouros
    } else if let licencasViewController = segue.destination as? LicencasViewController, let licencas = sender as? [Licenca] {
      licencasViewController.municipio = municipio
      licencasViewController.licencas = licencas
    } else if let licencaDetailViewController = segue.destination as? LicencaDetailViewController, let licenca = sender as? Licenca {
      licencaDetailViewController.licenca = licenca
    }
  }
}

// MARK: - Actions
extension ConsultaEnderecoViewController {
  @IBAction func tapped() {
    view.endEditing(true)
  }
  
  @IBAction func searchTapped() {
    guard let municipio = municipio, let query = enderecoTextField.text, query.characters.count > 0 else {
      return
    }
    progressHUD = ProgressHUD.present(with: "Buscando logradouros", in: view)
    municipio.licencas(with: query, number: numeroTextField.text ?? Municipio.defaultLogradouroNumber) { [weak self] inner in
      self?.progressHUD?.dismiss()
      do {
        let result = try inner()
        if let logradouros = result.logradouros {
          DispatchQueue.main.async {
            self?.performSegue(withIdentifier: "SegueLogradouros", sender: logradouros)
          }
        } else if let licencas = result.licencas, licencas.count > 0 {
          if licencas.count == 1 {
            DispatchQueue.main.async {
              self?.performSegue(withIdentifier: "SegueLicencaDetail", sender: licencas.first)
            }
          } else {
            DispatchQueue.main.async {
              self?.performSegue(withIdentifier: "SegueLicencas", sender: licencas)
            }
          }
        } else {
          Alert.present(title: "Atenção", message: "Nenhum registro encontrado.", in: self)
        }
      } catch {
        Alert.present(title: "Atenção", message: "Nenhum registro encontrado.", in: self)
      }
    }
  }
}

// MARK: - UITextField Delegate
extension ConsultaEnderecoViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    switch textField {
    case municipioTextField:
      performSegue(withIdentifier: "SegueSearchMunicipio", sender: nil)
      return false
    default:
      return true
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard textField == enderecoTextField else {
      return true
    }
    let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
    searchBarButtonItem.isEnabled = text.characters.count > 0
    numeroTextField.isEnabled = text.characters.count > 0
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case enderecoTextField:
      numeroTextField.becomeFirstResponder()
    case numeroTextField:
      searchTapped()
    default:
      break
    }
    return true
  }
}

// MARK: - UITableView Delegate
extension ConsultaEnderecoViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    for subview in cell.contentView.subviews {
      if let textField = subview as? UITextField {
        textField.becomeFirstResponder()
        return
      }
    }
  }
}
