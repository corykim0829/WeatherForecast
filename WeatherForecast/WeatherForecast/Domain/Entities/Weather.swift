//
//  Weather.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import Foundation

struct Weather {
  let date: Date
  let mainData: WeatherMainData
  let weatherDatas: [WeatherData]
  let clouds: WeatherClouds
  let wind: WeatherWind
}

struct WeatherMainData {
  let temp, tempMin, tempMax: Double
  let humidity: Int
}

struct WeatherData {
  let main, icon: String
}

struct WeatherClouds {
  let all: Int
}

struct WeatherWind {
  let speed: Double
  let gust: Double
}
