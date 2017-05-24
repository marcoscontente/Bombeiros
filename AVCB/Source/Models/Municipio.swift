//
//  City.swift
//  AVCB
//
//  Created by Gilson Gil on 27/01/17.
//  Copyright © 2017 Prodesp. All rights reserved.
//

import Foundation

final class Municipio {
  static let defaultLogradouroNumber = "0"
  
  let codigoMunicipio: Int
  let codigoMunicipioGB: String
  let codigoMunicipioCCB: String
  let codigoMunicipioPB: String
  let codigoMunicipioSGB: String
  let descricao: String
  let codigoPM: Int
  let identificadorMunicipio: Int
  
  init?(_ json: [String: AnyObject]) {
    guard let codigoMunicipio = json["CodigoMunicipio"] as? Int, let descricao = (json["Descricao"] as? String)?.uppercased() else {
      return nil
    }
    self.codigoMunicipio = codigoMunicipio
    self.descricao = descricao
    codigoMunicipioGB = (json["CodigoMunicipioGB"] as? String)?.uppercased() ?? ""
    codigoMunicipioPB = (json["CodigoMunicipioPB"] as? String)?.uppercased() ?? ""
    codigoMunicipioCCB = (json["CodigoMunicipioCCB"] as? String)?.uppercased() ?? ""
    codigoMunicipioSGB = (json["CodigoMunicipioSGB"] as? String)?.uppercased() ?? ""
    codigoPM = json["CodigoPM"] as? Int ?? 0
    identificadorMunicipio = json["IdentificadorMunicipio"] as? Int ?? 0
  }
}

// MARK: - Public
extension Municipio {
  func licencas(with query: String, number: String?, completion: @escaping (_ inner: () throws -> (logradouros: [Logradouro]?, licencas: [Licenca]?)) -> ()) {
    guard query.characters.count > 0 else {
      completion { throw Networking.defaultError }
      return
    }
    let logradouro = Logradouro(codigoMunicipio: codigoMunicipio, descricaoLogradouro: query)
    Networking.get(logradouro) { inner in
      do {
        let numero: String
        if let number = number, number.characters.count > 0 {
          numero = number
        } else {
          numero = Municipio.defaultLogradouroNumber
        }
        if let logradouros = try inner() as? [Logradouro], logradouros.count > 0 {
          if logradouros.count == 1 {
            let licenca = Licenca(codigoMunicipio: self.codigoMunicipio, codigoLogradouro: logradouros.first!.codigoLogradouro, numeroDoLogradouro: numero)
            Networking.get(licenca) { inner in
              do {
                guard let licencas = try inner() as? [Licenca] else {
                  return
                }
                print(licencas)
                completion { return (logradouros: nil, licencas: licencas) }
              } catch {
                completion { throw error }
              }
            }
          } else {
            completion { return (logradouros: logradouros, licencas: nil) }
          }
        } else {
          let licenca = Licenca(codigoMunicipio: self.codigoMunicipio, descricaoLogradouro: query, numeroDoLogradouro: numero)
          Networking.get(licenca) { inner in
            do {
              guard let licencas = try inner() as? [Licenca], licencas.count > 0 else {
                completion { throw Networking.defaultError }
                return
              }
              completion { return (logradouros: nil, licencas: licencas) }
            } catch {
              completion { throw error }
            }
          }
        }
      } catch {
        completion { throw error }
      }
    }
  }
  
  func licencas(with codigoLogradouro: Int, number: String?, completion: @escaping (_ inner: () throws -> [Licenca]) -> ()) {
    let licenca = Licenca(codigoMunicipio: self.codigoMunicipio, codigoLogradouro: codigoLogradouro, numeroDoLogradouro: number ?? Municipio.defaultLogradouroNumber)
    Networking.get(licenca) { inner in
      do {
        guard let licencas = try inner() as? [Licenca], licencas.count > 0 else {
          completion { throw Networking.defaultError }
          return
        }
        completion { return licencas }
      } catch {
        completion { throw error }
      }
    }
  }
}

extension Municipio: NetworkingProtocol {
  static var path: String {
    return "DmConsultarMunicipios/"
  }
}
