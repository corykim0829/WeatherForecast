//
//  CityListDTO.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation

struct CityDTO: Decodable {
  let id: Int
  let name, country: String
  let coord: Coordinate
  
  func toDomain() -> City {
    return .init(name: name, country: country, coord: coord)
  }
}
