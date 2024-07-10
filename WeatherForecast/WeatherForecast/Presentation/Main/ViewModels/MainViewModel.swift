//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
  
  // use case
  
  var weatherResponse = BehaviorRelay<WeatherResponse?>(value: nil)
  
  private let defaultCity = City(name: "Asan", coord: .init(lat: 36.783611, lon: 127.004173))
  
  init() {
    OpenWeatherAPI().fetchWeather(lat: defaultCity.coord.lat, lon: defaultCity.coord.lon) { result in
      switch result {
      case .success(let response):
        let weatherResponse = response.toDomain()
        self.weatherResponse.accept(weatherResponse)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  
}
