//
//  FetchWeatherUseCase.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation

final class FetchWeatherUseCase {
  
  let weatherRepository: DefaultRemoteWeatherRepository
  
  init(weatherRepository: DefaultRemoteWeatherRepository = DefaultRemoteWeatherRepository()) {
    self.weatherRepository = weatherRepository
  }
  
  func fetchWeather(city: City, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
    weatherRepository.fetchWeather(city: city, completion: completion)
  }
}
