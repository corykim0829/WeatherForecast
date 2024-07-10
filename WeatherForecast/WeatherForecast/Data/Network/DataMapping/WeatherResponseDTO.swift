//
//  WeatherResponseDTO.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import Foundation

struct WeatherResponseDTO: Decodable {
  let cod: String
  let message, cnt: Int
  let list: [WeatherDTO]
  let city: CityDTO
}

extension WeatherResponseDTO {
  struct WeatherDTO: Decodable {
    let dt: Int
    let main: MainDataDTO
    let weatherDatas: [weatherDataDTO]
    let clouds: CloudsDTO
    let wind: WindDTO
    let visibility: Int
    let pop: Double
    let rain: RainDTO?
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
      case dt, main, clouds, wind, visibility, pop, rain
      case weatherDatas = "weather"
      case dtTxt = "dt_txt"
    }
    
    func toDomain() -> Weather {
      .init(
        date: Date(timeIntervalSince1970: TimeInterval(dt)),
        mainData: main.toDomain(),
        weatherDatas: weatherDatas.map { $0.toDomain() },
        clouds: clouds.toDomain(),
        wind: wind.toDomain())
    }
  }
}

extension WeatherResponseDTO {
  struct CityDTO: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population, timezone, sunrise, sunset: Int
    
    func toDomain() -> City {
      return City(name: name, coord: coord)
    }
  }
}

extension WeatherResponseDTO.WeatherDTO {
  struct MainDataDTO: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
      case temp
      case feelsLike = "feels_like"
      case tempMin = "temp_min"
      case tempMax = "temp_max"
      case pressure
      case seaLevel = "sea_level"
      case grndLevel = "grnd_level"
      case humidity
      case tempKf = "temp_kf"
    }
    
    func toDomain() -> WeatherMainData {
      return .init(
        temp: temp,
        tempMin: tempMin,
        tempMax: tempMax,
        humidity: humidity)
    }
  }
}

extension WeatherResponseDTO.WeatherDTO {
  struct weatherDataDTO: Decodable {
    let id: Int
    let main: String
    let description, icon: String
    
    func toDomain() -> WeatherData {
      return WeatherData(main: main, icon: icon)
    }
  }
}

extension WeatherResponseDTO.WeatherDTO {
  struct CloudsDTO: Decodable {
    let all: Int
    
    func toDomain() -> WeatherClouds {
      return .init(all: all)
    }
  }
  
  struct WindDTO: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
    
    func toDomain() -> WeatherWind {
      return .init(speed: speed)
    }
  }
  
  struct RainDTO: Decodable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
      case the3H = "3h"
    }
  }
}
