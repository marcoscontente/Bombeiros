//
//  Logradouro.swift
//  AVCB
//
//  Created by Gilson Gil on 30/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import Foundation

final class Logradouro {
  let codigoLogradouro: Int
  let codigoMunicipio: Int
  let descricaoBairro: String
  let descricaoLogradouro: String
  let descricaoMunicipio: String
  let descricaoUf: String
  
  init?(_ json: [String: AnyObject]) {
    guard let codigoLogradouro = json["CodigoLogradouro"] as? Int, let codigoMunicipio = json["CodigoMunicipio"] as? Int, let descricaoLogradouro = (json["DescricaoLogradouro"] as? String)?.uppercased() else {
      return nil
    }
    self.codigoLogradouro = codigoLogradouro
    self.codigoMunicipio = codigoMunicipio
    self.descricaoBairro = (json["DescricaoBairro"] as? String)?.uppercased() ?? ""
    self.descricaoLogradouro = descricaoLogradouro
    self.descricaoMunicipio = (json["DescricaoMunicipio"] as? String)?.uppercased() ?? ""
    self.descricaoUf = (json["DescricaoUf"] as? String)?.uppercased() ?? ""
  }
  
  init(codigoMunicipio: Int, descricaoLogradouro: String) {
    self.codigoLogradouro = 0
    self.codigoMunicipio = codigoMunicipio
    self.descricaoBairro = ""
    self.descricaoLogradouro = descricaoLogradouro
    self.descricaoMunicipio = ""
    self.descricaoUf = ""
  }
}

extension Logradouro: NetworkingProtocol {
  var path: String {
    return "DMConsultaLogradouros/\(codigoMunicipio)/\(descricaoLogradouro)"
  }
}
