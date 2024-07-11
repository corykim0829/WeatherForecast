//
//  FetchCityListUseCase.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation

final class FetchCityListUseCase {
  
  let localCitiesRepository: DefaultLocalCitiesRepository
  
  init(localCitiesRepository: DefaultLocalCitiesRepository = DefaultLocalCitiesRepository()) {
    self.localCitiesRepository = localCitiesRepository
  }
  
  func fetchCityList() -> [City] {
    return localCitiesRepository.fetchCities().map { $0.toDomain() }
  }
}
