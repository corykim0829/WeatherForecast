//
//  DefaultRemoteWeatherRepository.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation

final class DefaultRemoteWeatherRepository {
  
  let openWeatherAPI: OpenWeatherAPI
  
  init(openWeatherAPI: OpenWeatherAPI = OpenWeatherAPI()) {
    self.openWeatherAPI = openWeatherAPI
  }
  
  func fetchWeather(city: City, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
    openWeatherAPI.fetchWeather(lat: city.coord.lat, lon: city.coord.lon) { result in
      switch result {
      case .success(let response):
        let weatherResponse = response.toDomain()
        completion(.success(weatherResponse))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
