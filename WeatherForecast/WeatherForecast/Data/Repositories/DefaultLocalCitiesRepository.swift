//
//  DefaultLocalCitiesRepository.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation

final class DefaultLocalCitiesRepository {
  
  func fetchCities() -> [CityDTO] {
    guard
      let jsonData = loadCityListData(),
      let cities = try? JSONDecoder().decode([CityDTO].self, from: jsonData) else {
      return []
    }
    
    return cities
  }
  
  private func loadCityListData() -> Data? {
    let fileName = "reduced_citylist"
    let extensionType = "json"
    guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
      return nil
    }
    
    do {
      let data = try Data(contentsOf: fileLocation)
      return data
    } catch {
      return nil
    }
  }
  
}
