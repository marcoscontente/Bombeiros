import UIKit

final class LicenseCell: UITableViewCell {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(_ info: String?, address: String?, licenseType: String?) {
        infoLabel.text = info
        addressLabel.text = address
        guard let licenseType = licenseType else {
            return
        }
        switch licenseType {
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
