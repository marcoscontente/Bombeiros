import UIKit

class CityViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var cityFilteredList: [Municipio]?
    fileprivate var cityList: [Municipio]?
    var selectedCityId: Int?
    fileprivate var filtered = false
    fileprivate let api = ApiClientRepository()
    fileprivate weak var progressHUD: ProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        getAction()
        
        scroll(to: selectedCityId)
        
        navigationItem.titleView = searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let LookUpAddressViewController = segue.destination as? LookUpAddressViewController, let city = sender as? Municipio else {
            return
        }
        LookUpAddressViewController.city = city
    }
    
    func scroll(to cityId: Int?) {
        guard let cityId = cityId else {
            return
        }
        if let cityList = cityList, let index = cityList.index(where: {$0.codigoMunicipio == cityId}) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func getAction() {
        progressHUD = ProgressHUD.present(with: "Buscando municípios", in: view)
        Networking.get(Municipio.self) { [weak self] inner in
            self?.progressHUD?.dismiss()
            do {
                guard let cities = try inner() as? [Municipio] else {
                    return
                }
                self?.cityList = cities
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.scroll(to: self?.selectedCityId)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func didTapView(sender: AnyObject) {
        view.endEditing(true)
    }
}

// MARK: - UISearchBar Delegate
extension CityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.characters.count == 0) {
            filtered = false
        } else {
            filtered = true;
            cityFilteredList = cityList?.filter {
                $0.descricao.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource
extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered {
            return cityFilteredList?.count ?? 0
        } else {
            return cityList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        let city = (filtered ? cityFilteredList?[indexPath.row] : cityList?[indexPath.row])
        cell.accessoryType = ( city?.codigoMunicipio == selectedCityId ? .checkmark : .none )
        cell.textLabel?.text = city?.descricao
        return cell
    }
}

// MARK: - UITableView Delegate
extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = (filtered ? cityFilteredList?[indexPath.row] : cityList?[indexPath.row])
        selectedCityId = city?.codigoMunicipio
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        performSegue(withIdentifier: "segueCity", sender: city)
    }
}
