import UIKit

class AddressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate weak var progressHUD: ProgressHUD?
    
    var addresses = [Logradouro]()
    var city: Municipio?
    var number: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let licensesViewController = segue.destination as? LicensesViewController, let licenses = sender as? [Licenca] {
            licensesViewController.licenses = licenses
            licensesViewController.city = city
            if let indexPath = tableView.indexPathForSelectedRow {
                licensesViewController.address = addresses[indexPath.row]
            }
        }
    }
}

// MARK: - UITableView DataSource
extension AddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        let address = addresses[indexPath.row]
        cell.textLabel?.text = address.descricaoLogradouro + " - " + address.descricaoBairro
        return cell
    }
}

// MARK: - UITableView Delegate
extension AddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        progressHUD = ProgressHUD.present(with: "Buscando licenças", in: view)
        city?.licencas(with: address.codigoLogradouro, number: number) { [weak self] inner in
            self?.progressHUD?.dismiss()
            do {
                let licenses = try inner()
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "SegueLicenses", sender: licenses)
                }
            } catch {
                Alert.present(title: "Atenção", message: "Nenhum registro encontrado", in: self)
            }
        }
    }
}
