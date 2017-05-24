//
//  Licenca.swift
//  AVCB
//
//  Created by Gilson Gil on 30/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import Foundation

final class Licenca: NSObject {
  let areaTotal: Double
  let areaVistoriada: Double
  let codigoLogradouro: Int
  let dataEmissao: String
  let dataVigencia: String
  let descricaoBairro: String
  let descricaoComplemento: String
  let descricaoLogradouro: String
  let descricaoMunicipio: String
  let descricaoOcupacao: String
  let descricaoSituacaoLicenca: String
  let descricaoTipoLicenca: String
  let identificadorLicenca: Int
  let nomeProprietario: String
  let nomeResponsavelTecnico: String
  let numeroDoLogradouro: String
  let observacaoLicenca: String
  let codigoMunicipio: Int
  
  init?(_ json: [String: AnyObject]) {
    self.areaTotal = (json["AreaTotal"] as? Double) ?? 0
    self.areaVistoriada = (json["AreaVistoriada"] as? Double) ?? 0
    self.codigoLogradouro = (json["CodigoLogradouro"] as? Int) ?? 0
    self.dataEmissao = (json["DataEmissao"] as? String) ?? ""
    self.dataVigencia = (json["DataVigencia"] as? String) ?? (json["Validade"] as? String) ?? ""
    self.descricaoBairro = (json["DescricaoBairro"] as? String) ?? ""
    self.descricaoComplemento = (json["DescricaoComplemento"] as? String) ?? ""
    self.descricaoLogradouro = (json["DescricaoLogradouro"] as? String) ?? ((json["DadosLogradouro"] as? String)) ?? ""
    self.descricaoMunicipio = (json["DescricaoMunicipio"] as? String) ?? ""
    self.descricaoOcupacao = (json["DescricaoOcupacao"] as? String) ?? ""
    self.descricaoSituacaoLicenca = (json["DescricaoSituacaoLicenca"] as? String) ?? (json["Situacao"] as? String) ?? ""
    self.descricaoTipoLicenca = (json["DescricaoTipoLicenca"] as? String) ?? ""
    if let id = json["IdentificadorLicenca"] as? Int {
      self.identificadorLicenca = id
    } else if let id = json["Numero"] as? String {
      self.identificadorLicenca = Int(id) ?? 0
    } else {
      self.identificadorLicenca = 0
    }
    self.nomeProprietario = (json["NomeProprietario"] as? String) ?? (json["RazaoSocial"] as? String) ?? ""
    self.nomeResponsavelTecnico = (json["NomeResponsavelTecnico"] as? String) ?? ""
    self.numeroDoLogradouro = (json["NumeroDoLogradouro"] as? String) ?? ""
    self.observacaoLicenca = (json["ObservacaoLicenca"] as? String) ?? ((json["Observacoes"] as? String)) ?? "-"
    self.codigoMunicipio = 0
  }
  
  init(codigoMunicipio: Int, descricaoLogradouro: String, numeroDoLogradouro: String) {
    self.areaTotal = 0
    self.areaVistoriada = 0
    self.codigoLogradouro = 0
    self.dataEmissao = ""
    self.dataVigencia = ""
    self.descricaoBairro = ""
    self.descricaoComplemento = ""
    self.descricaoLogradouro = descricaoLogradouro
    self.descricaoMunicipio = String(codigoMunicipio)
    self.descricaoOcupacao = ""
    self.descricaoSituacaoLicenca = ""
    self.descricaoTipoLicenca = ""
    self.identificadorLicenca = 0
    self.nomeProprietario = ""
    self.nomeResponsavelTecnico = ""
    self.numeroDoLogradouro = numeroDoLogradouro
    self.observacaoLicenca = ""
    self.codigoMunicipio = codigoMunicipio
  }
  
  init(codigoMunicipio: Int, codigoLogradouro: Int, numeroDoLogradouro: String) {
    self.areaTotal = 0
    self.areaVistoriada = 0
    self.codigoLogradouro = codigoLogradouro
    self.dataEmissao = ""
    self.dataVigencia = ""
    self.descricaoBairro = ""
    self.descricaoComplemento = ""
    self.descricaoLogradouro = ""
    self.descricaoMunicipio = String(codigoMunicipio)
    self.descricaoOcupacao = ""
    self.descricaoSituacaoLicenca = ""
    self.descricaoTipoLicenca = ""
    self.identificadorLicenca = 0
    self.nomeProprietario = ""
    self.nomeResponsavelTecnico = ""
    self.numeroDoLogradouro = numeroDoLogradouro
    self.observacaoLicenca = ""
    self.codigoMunicipio = codigoMunicipio
  }
}

extension Licenca: NetworkingProtocol {
  var path: String {
    if codigoLogradouro == 0 {
      return "DMConsultaLicencaPorDescricaoLogradouro/\(descricaoLogradouro)/\(codigoMunicipio)/\(numeroDoLogradouro)"
    } else {
      return "DMConsultaLicencaPorCodigoLogradouro/\(codigoLogradouro)/\(codigoMunicipio)/\(numeroDoLogradouro)"
    }
  }
}
