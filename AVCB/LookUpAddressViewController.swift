import Foundation

import UIKit

final class LookUpAddressViewController: UITableViewController {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    fileprivate weak var progressHUD: ProgressHUD?
    
    var city: Municipio? {
        didSet {
            cityTextField.text = city?.descricao
        }
    }
}

// MARK: - Segues
extension LookUpAddressViewController {
    @IBAction func unwindFromCity(segue: UIStoryboardSegue) {
        streetTextField.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let cityViewController = segue.destination as? CityViewController {
            cityViewController.selectedCityId = city?.codigoMunicipio
        } else if let addressViewController = segue.destination as? AddressViewController, let address = sender as? [Logradouro] {
            addressViewController.city = city
            addressViewController.addresses = address
        } else if let licensesViewController = segue.destination as? LicensesViewController, let licenses = sender as? [Licenca] {
            licensesViewController.city = city
            licensesViewController.licenses = licenses
        } else if let licenseDetailViewController = segue.destination as? LicenseDetailViewController, let licenses = sender as? Licenca {
            licenseDetailViewController.license = licenses
        }
    }
}

// MARK: - Actions
extension LookUpAddressViewController {
    @IBAction func tapped() {
        view.endEditing(true)
    }
    
    @IBAction func searchTapped() {
        guard let municipio = city, let query = streetTextField.text, query.characters.count > 0 else {
            return
        }
        progressHUD = ProgressHUD.present(with: "Buscando logradouros", in: view)
        municipio.licencas(with: query, number: numberTextField.text ?? Municipio.defaultLogradouroNumber) { [weak self] inner in
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
extension LookUpAddressViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case cityTextField:
            performSegue(withIdentifier: "SegueSearchCity", sender: nil)
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == streetTextField else {
            return true
        }
        let text = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        searchBarButtonItem.isEnabled = text.characters.count > 0
        numberTextField.isEnabled = text.characters.count > 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case streetTextField:
            numberTextField.becomeFirstResponder()
        case numberTextField:
            searchTapped()
        default:
            break
        }
        return true
    }
}

// MARK: - UITableView Delegate
extension LookUpAddressViewController {
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
