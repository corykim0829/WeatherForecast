//
//  MainCityWeatherView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/9/24.
//

import UIKit
import SnapKit

final class MainCityWeatherView: UIView {
  
  lazy var cityTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 40, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  lazy var currentTemperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 50, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  lazy var weatherLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 34, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(weatherResponse: WeatherResponse) {
    guard let currentWeather = weatherResponse.weathers.first,
          let weatherData = currentWeather.weatherDatas.first 
    else {
      return
    }
    
    cityTitleLabel.text = weatherResponse.city.name
    currentTemperatureLabel.text = "\(Int(round(currentWeather.mainData.temp)))º"
    weatherLabel.text = weatherData.main
    let tempMax = Int(round(currentWeather.mainData.tempMax))
    let tempMin = Int(round(currentWeather.mainData.tempMin))
    temperatureLabel.text = "최고: \(tempMax)º  |  최저: \(tempMin)º"
  }
  
}

extension MainCityWeatherView {
  private func configure() {
    backgroundColor = .darkGray
    layout()
  }
  
  private func layout() {
    addSubview(cityTitleLabel)
    cityTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(24)
      $0.centerX.equalToSuperview()
    }
    addSubview(currentTemperatureLabel)
    currentTemperatureLabel.snp.makeConstraints {
      $0.top.equalTo(cityTitleLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
    }
    
    addSubview(weatherLabel)
    weatherLabel.snp.makeConstraints {
      $0.top.equalTo(currentTemperatureLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
    }
    
    addSubview(temperatureLabel)
    temperatureLabel.snp.makeConstraints {
      $0.top.equalTo(weatherLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(16)
    }
    
  }
  
}
