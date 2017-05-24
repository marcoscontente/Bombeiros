import UIKit
import CoreLocation

final class LicenseDetailViewController: UIViewController {
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var avcbLabel: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var corporateNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ocupationLabel: UILabel!
    @IBOutlet weak var observationsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var license: Licenca?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let license = license else {
            return
        }
        avcbLabel.text = String(license.identificadorLicenca)
        situationLabel.text = license.descricaoSituacaoLicenca
        validityLabel.text = license.dataVigencia
        corporateNameLabel.text = license.nomeProprietario
        addressLabel.text = "\(license.descricaoLogradouro), \(license.numeroDoLogradouro), \(license.descricaoBairro) - \(license.descricaoMunicipio)"
        ocupationLabel.text = license.descricaoOcupacao
        observationsLabel.text = license.observacaoLicenca
        GoogleStaticMapsHelper.map(for: "\(license.descricaoLogradouro),\(license.numeroDoLogradouro)", size: mapButton.bounds.size) { [weak self] inner in
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
            locationLabel.text = "A sua localização encontra-se a mais de 100 metros do endereço indicado"
        } else {
            locationLabel.text = "A sua localização encontra-se a menos de 100 metros do endereço indicado"
        }
    }
}

// MARK: - Actions
extension LicenseDetailViewController {
    @IBAction func mapTapped() {
        guard let address = addressLabel.text else {
            return
        }
        MapsHandler.open(query: address, from: self)
    }
}

// MARK: - UIActionSheet Delegate
extension LicenseDetailViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        guard buttonIndex != actionSheet.cancelButtonIndex else {
            return
        }
        guard let address = addressLabel.text else {
            return
        }
        if buttonIndex == 0 {
            MapsHandler.openGoogleMaps(query: address)
        } else {
            MapsHandler.openMaps(query: address)
        }
    }
}
