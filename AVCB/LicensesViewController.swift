import UIKit

class LicensesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var neighborhoodLabel: UILabel!
    
    var licenses = [Licenca]()
    var city: Municipio?
    var address: Logradouro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        cityLabel.text = city?.descricao
        addressLabel.text = address?.descricaoLogradouro
        neighborhoodLabel.text = address?.descricaoBairro
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        guard let LicenseDetailViewController = segue.destination as? LicenseDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let license = licenses[indexPath.row]
        LicenseDetailViewController.license = license
    }
}

// MARK: - Actions
extension LicensesViewController {
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
extension LicensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LicenseCell else {
            return UITableViewCell()
        }
        
        let license = licenses[indexPath.row]
        cell.configure(license.descricaoOcupacao, address: license.descricaoLogradouro + ", " + license.descricaoBairro, licenseType: license.descricaoTipoLicenca)
        return cell
    }
}
