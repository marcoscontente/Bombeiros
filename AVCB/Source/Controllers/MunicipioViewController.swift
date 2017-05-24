//
//  CityViewController.swift
//  AVCB
//
//  Created by Gilson Gil on 27/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import UIKit

class MunicipioViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var municipioFilteredList: [Municipio]?
  fileprivate var municipioList: [Municipio]?
  var selectedMunicipioId: Int?
  fileprivate var filtered = false
  fileprivate let api = ApiClientRepository()
  fileprivate weak var progressHUD: ProgressHUD?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  
  private func setUp() {
    getAction()
    
    scroll(to: selectedMunicipioId)
    
    navigationItem.titleView = searchBar
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let consultaEnderecoViewController = segue.destination as? ConsultaEnderecoViewController, let municipio = sender as? Municipio else {
      return
    }
    consultaEnderecoViewController.municipio = municipio
  }
  
  func scroll(to municipioId: Int?) {
    guard let municipioId = municipioId else {
      return
    }
    if let municipioList = municipioList, let index = municipioList.index(where: {$0.codigoMunicipio == municipioId}) {
      let indexPath = IndexPath(row: index, section: 0)
      tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
  }
  
  func getAction() {
    progressHUD = ProgressHUD.present(with: "Buscando municípios", in: view)
    Networking.get(Municipio.self) { [weak self] inner in
      self?.progressHUD?.dismiss()
      do {
        guard let municipios = try inner() as? [Municipio] else {
          return
        }
        self?.municipioList = municipios
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.scroll(to: self?.selectedMunicipioId)
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
extension MunicipioViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if(searchText.characters.count == 0) {
      filtered = false
    } else {
      filtered = true;
      municipioFilteredList = municipioList?.filter {
        $0.descricao.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil
      }
    }
    tableView.reloadData()
  }
}

// MARK: - UITableView DataSource
extension MunicipioViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if filtered {
      return municipioFilteredList?.count ?? 0
    } else {
      return municipioList?.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
      return UITableViewCell()
    }
    
    let municipio = (filtered ? municipioFilteredList?[indexPath.row] : municipioList?[indexPath.row])
    cell.accessoryType = ( municipio?.codigoMunicipio == selectedMunicipioId ? .checkmark : .none )
    cell.textLabel?.text = municipio?.descricao
    return cell
  }
}

// MARK: - UITableView Delegate
extension MunicipioViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let municipio = (filtered ? municipioFilteredList?[indexPath.row] : municipioList?[indexPath.row])
    selectedMunicipioId = municipio?.codigoMunicipio
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
    }
    performSegue(withIdentifier: "segueMunicipio", sender: municipio)
  }
}
