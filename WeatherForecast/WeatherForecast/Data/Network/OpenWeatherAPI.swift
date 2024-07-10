//
//  OpenWeatherAPI.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import Foundation
import Alamofire

final class OpenWeatherAPI {
  
  func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponseDTO, AFError>) -> Void) {
    let url = "http://api.openweathermap.org/data/2.5/forecast"
    let appID = "381e2aad322fcd7037beac2ce6027c81"
    let parameters = [
      "lat": lat,
      "lon": lon,
      "appid": appID,
      "units": "metric"
    ] as [String : Any]
    let AFSession = AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300)
    AFSession.responseDecodable(of: WeatherResponseDTO.self) { response in
      completion(response.result)
    }
  }
  
}
