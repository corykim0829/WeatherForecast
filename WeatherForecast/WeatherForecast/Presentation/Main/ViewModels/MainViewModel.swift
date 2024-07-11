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
  
  let fetchWeatherUseCase: FetchWeatherUseCase
  
  var weatherResponse = BehaviorRelay<WeatherResponse?>(value: nil)
  var weathersByHour = PublishRelay<[Weather]>()
  var weathersForFiveDays = PublishRelay<[WeatherByDay]>()
  var isFetching = BehaviorRelay<Bool>(value: false)
  var errorOccurred = PublishRelay<Error>()
  
  private let defaultCity = City(name: "Asan", country: "KR", coord: .init(lat: 36.783611, lon: 127.004173))
  
  let disposeBag = DisposeBag()
  
  init(fetchWeatherUseCase: FetchWeatherUseCase = FetchWeatherUseCase()) {
    self.fetchWeatherUseCase = fetchWeatherUseCase
    
    self.isFetching.accept(true)
    self.fetchWeatherUseCase.fetchWeather(city: defaultCity) { result in
      switch result {
      case .success(let response):
        self.isFetching.accept(false)
        self.weatherResponse.accept(response)
      case .failure(let error):
        self.isFetching.accept(false)
        self.errorOccurred.accept(error)
      }
    }
    
    weatherResponse
      .share(replay: 1)
      .subscribe { weatherResponse in
        if let weatherResponse = weatherResponse {
          let weatherByHourList = self.weatherByHourList(response: weatherResponse)
          self.weathersByHour.accept(weatherByHourList)
        }
      }
      .disposed(by: disposeBag)
    
    weatherResponse
      .share(replay: 1)
      .subscribe { weatherResponse in
        if let weatherResponse = weatherResponse {
          let weatherByDayList = self.weatherByDayList(response: weatherResponse)
          self.weathersForFiveDays.accept(weatherByDayList)
        }
      }
      .disposed(by: disposeBag)
  }
  
  func fetchWeather(city: City) {
    isFetching.accept(true)
    fetchWeatherUseCase.fetchWeather(city: city) { result in
      switch result {
      case .success(let response):
        self.isFetching.accept(false)
        self.weatherResponse.accept(response)
      case .failure(let error):
        self.isFetching.accept(false)
        self.errorOccurred.accept(error)
      }
    }
  }
  
  private func weatherByHourList(response: WeatherResponse) -> [Weather] {
    return response
      .weathers
      .filter {
        $0.date <= Date().addingTimeInterval(60 * 60 * 24 * 2)
      }
  }
  
  private func weatherByDayList(response: WeatherResponse) -> [WeatherByDay] {
    var weathersByDate: [String: [Weather]] = [:]
    response
      .weathers
      .filter {
        $0.date <= Date().addingTimeInterval(60 * 60 * 24 * 4)
      }
      .forEach {
        let dateKey = dateFormatter.string(from: $0.date)
        var newValue: [Weather] = weathersByDate[dateKey] ?? []
        newValue.append($0)
        weathersByDate[dateKey] = newValue
      }
    
    let result: [WeatherByDay] = weathersByDate.map { key, value in
      let date = dateFormatter.date(from: key)
      let tempMin = value.map {
        $0.mainData.tempMin
      }.min()
      let tempMax = value.map {
        $0.mainData.tempMax
      }.max()
      let icon = value.first?.weatherDatas.first?.icon
      
      if let date = date, let tempMin = tempMin, let tempMax = tempMax, let icon = icon {
        return WeatherByDay(date: date, tempMin: tempMin, tempMax: tempMax, weatherIcon: icon)
      } else {
        return nil
      }
    }.compactMap { $0 }
    
    return result
  }
  
}

private let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyyMMdd"
  dateFormatter.locale = Locale(identifier: "ko_KR")
  return dateFormatter
}()
